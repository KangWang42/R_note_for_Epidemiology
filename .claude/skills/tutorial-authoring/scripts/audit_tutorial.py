#!/usr/bin/env python3
"""Lightweight structural audit for this repository's Rmd/Qmd tutorials."""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path


FRONTMATTER_RE = re.compile(r"\A---\s*\n(.*?)\n---\s*\n", re.S)
CHUNK_RE = re.compile(r"^```\{(?:r|python)(?:\s+([^,}\s]+))?", re.M)
IMAGE_RE = re.compile(r"!\[([^\]]*)\]\(([^)\s]+)(?:\s+[^)]*)?\)")
INLINE_CODE_RE = re.compile(r"`[^`\n]*`")
UNSUPPORTED_MATH_DELIMITER_RE = re.compile(r"\\[()[\]]")


def unsupported_math_delimiter_lines(text: str) -> list[int]:
    """Find unsupported TeX math delimiters in prose, excluding fenced/inline code."""
    matches: list[int] = []
    fence_marker: str | None = None

    for line_number, line in enumerate(text.splitlines(), start=1):
        stripped = line.lstrip()
        marker = next(
            (candidate for candidate in ("```", "~~~") if stripped.startswith(candidate)),
            None,
        )
        if marker:
            if fence_marker is None:
                fence_marker = marker
            elif marker == fence_marker:
                fence_marker = None
            continue
        if fence_marker is not None:
            continue
        prose = INLINE_CODE_RE.sub("", line)
        if UNSUPPORTED_MATH_DELIMITER_RE.search(prose):
            matches.append(line_number)

    return matches


def field_present(frontmatter: str, field: str) -> bool:
    return re.search(rf"(?m)^{re.escape(field)}\s*:\s*\S*", frontmatter) is not None


def audit(path: Path) -> tuple[list[str], list[str], dict[str, int]]:
    errors: list[str] = []
    warnings: list[str] = []
    stats = {"h2": 0, "chunks": 0, "images": 0}

    if path.suffix.lower() not in {".rmd", ".qmd"}:
        return ["文件扩展名不是 .rmd 或 .qmd"], warnings, stats

    try:
        text = path.read_text(encoding="utf-8")
    except UnicodeDecodeError as exc:
        return [f"不是有效 UTF-8：{exc}"], warnings, stats

    if "\ufffd" in text:
        errors.append("包含 Unicode replacement character，可能存在乱码")
    mojibake = ("锟斤拷", "Ã", "Â", "â€™", "â€“", "â€œ")
    if any(marker in text for marker in mojibake):
        errors.append("命中常见乱码片段，请核对文件编码")

    frontmatter_match = FRONTMATTER_RE.search(text)
    if not frontmatter_match:
        errors.append("缺少完整 YAML frontmatter")
        frontmatter = ""
    else:
        frontmatter = frontmatter_match.group(1)
        for field in ("title", "date", "categories"):
            if not field_present(frontmatter, field):
                errors.append(f"YAML 缺少 {field}")
        if not field_present(frontmatter, "description"):
            warnings.append("YAML 缺少 description")
        image_match = re.search(r'(?m)^image\s*:\s*["\']?([^"\'\n]+)', frontmatter)
        if image_match:
            image_href = image_match.group(1).strip()
            image_target = path.parent / image_href
            if not image_target.exists():
                errors.append(f"YAML image 不存在：{image_href}")

    stats["h2"] = len(re.findall(r"(?m)^##\s+\S", text))
    if stats["h2"] < 3:
        warnings.append("少于 3 个二级标题；请确认文章是否足以形成教程")

    fence_count = len(re.findall(r"(?m)^```", text))
    if fence_count % 2:
        errors.append("代码围栏数量为奇数，可能存在未闭合代码块")

    labels = [label for label in CHUNK_RE.findall(text) if label]
    stats["chunks"] = len(CHUNK_RE.findall(text))
    duplicates = sorted({label for label in labels if labels.count(label) > 1})
    if duplicates:
        errors.append("重复 chunk 标签：" + ", ".join(duplicates))

    delimiter_lines = unsupported_math_delimiter_lines(text)
    if delimiter_lines:
        line_list = ", ".join(str(line) for line in delimiter_lines)
        errors.append(
            "正文使用当前渲染链不支持的 LaTeX 定界符 "
            rf"\(...\) 或 \[...\]（行 {line_list}）；请使用 $...$ 或 $$...$$"
        )

    images = IMAGE_RE.findall(text)
    stats["images"] = len(images)
    for alt, href in images:
        if not alt.strip():
            warnings.append(f"图片缺少替代文本：{href}")
        if re.match(r"^(?:https?://|data:|#)", href):
            continue
        target = Path(href)
        if not target.is_absolute():
            target = path.parent / target
        if not target.exists():
            errors.append(f"本地图片不存在：{href}")

    return errors, warnings, stats


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("files", nargs="+", type=Path)
    args = parser.parse_args()

    total_errors = 0
    for path in args.files:
        if not path.exists():
            print(f"ERROR {path}: 文件不存在")
            total_errors += 1
            continue
        errors, warnings, stats = audit(path)
        for message in errors:
            print(f"ERROR {path}: {message}")
        for message in warnings:
            print(f"WARN  {path}: {message}")
        print(
            f"INFO  {path}: h2={stats['h2']} chunks={stats['chunks']} "
            f"images={stats['images']} errors={len(errors)} warnings={len(warnings)}"
        )
        total_errors += len(errors)

    return 1 if total_errors else 0


if __name__ == "__main__":
    sys.exit(main())
