const SITE_URL = "https://r.wk8686.top/";
const SITE_NAME = "R 语言学习笔记";
const SITE_DESCRIPTION = "面向流行病学、生物统计与数据科学实践的 R 语言中文教程，覆盖研究设计、统计建模、数据处理、科研绘图与可复现工作流。";
const GENERIC_DESCRIPTIONS = new Set([
  SITE_DESCRIPTION,
  "R 语言学习笔记 - 涵盖统计分析、数据可视化、机器学习与因果推断的全面教程资源库。从基础到高级，为数据科学家和研究人员提供实用的R语言指南。"
]);
const MAX_SECTION_TEXT = 30_000;
const NOINDEX_HTML = new Set(["SIDEBAR_README.html", "test.html"]);
const CANONICAL_ALIASES = new Map([
  ["1016-questionnaire-validity.html", "1128-questionnaire-validity.html"]
]);

interface SearchEntry {
  href: string;
  text?: string;
  [key: string]: unknown;
}

const outputSetting = Deno.env.get("QUARTO_PROJECT_OUTPUT_DIR") || "../public";
const outputDir = Deno.realPathSync(outputSetting).replaceAll("\\", "/");
const searchPath = `${outputDir}/search.json`;

function localPath(href: string): { file: string; anchor: string } | null {
  if (!href || /^[a-z]+:/i.test(href)) return null;
  const [pathAndQuery, rawAnchor = ""] = href.split("#", 2);
  const rawPath = pathAndQuery.split("?", 1)[0] || "index.html";
  try {
    return {
      file: decodeURIComponent(rawPath),
      anchor: decodeURIComponent(rawAnchor)
    };
  } catch (_) {
    return { file: rawPath, anchor: rawAnchor };
  }
}

function truncateSearchText(text = ""): string {
  if (text.length <= MAX_SECTION_TEXT) return text;
  const headLength = 18_000;
  const tailLength = 10_000;
  return `${text.slice(0, headLength)}\n\n[过长的程序输出已从搜索索引中省略]\n\n${text.slice(-tailLength)}`;
}

function optimizeSearchIndex(): void {
  try {
    const entries = JSON.parse(Deno.readTextFileSync(searchPath)) as SearchEntry[];
    const idCache = new Map<string, Set<string>>();
    const optimized = new Map<string, SearchEntry>();
    let removed = 0;
    let truncated = 0;

    for (const entry of entries) {
      const target = localPath(entry.href);
      if (!target || NOINDEX_HTML.has(target.file) || CANONICAL_ALIASES.has(target.file)) {
        removed++;
        continue;
      }

      const htmlPath = `${outputDir}/${target.file}`;
      let ids = idCache.get(htmlPath);
      if (!ids) {
        try {
          const html = Deno.readTextFileSync(htmlPath);
          ids = new Set([...html.matchAll(/\sid="([^"]+)"/g)].map((match) => match[1]));
          idCache.set(htmlPath, ids);
        } catch (_) {
          removed++;
          continue;
        }
      }

      if (target.anchor && !ids.has(target.anchor)) {
        removed++;
        continue;
      }

      const text = entry.text || "";
      const shortened = truncateSearchText(text);
      if (shortened.length !== text.length) truncated++;
      if (optimized.has(entry.href)) removed++;
      optimized.set(entry.href, { ...entry, text: shortened });
    }

    Deno.writeTextFileSync(searchPath, JSON.stringify([...optimized.values()]));
    if (Deno.env.get("QUARTO_PROJECT_SCRIPT_QUIET") !== "1") {
      console.log(
        `Search index: ${entries.length} -> ${optimized.size} entries; ` +
        `${removed} stale/duplicate entries removed; ${truncated} oversized sections shortened.`
      );
    }
  } catch (error) {
    if (error instanceof Deno.errors.NotFound) return;
    throw error;
  }
}

function listHtmlFiles(directory: string): string[] {
  const files: string[] = [];
  for (const item of Deno.readDirSync(directory)) {
    const fullPath = `${directory}/${item.name}`;
    if (item.isDirectory) {
      if (item.name !== "site_libs") files.push(...listHtmlFiles(fullPath));
    } else if (item.isFile && item.name.endsWith(".html") && item.name !== "404.html") {
      files.push(fullPath);
    }
  }
  return files;
}

function metaContent(html: string, attribute: "name" | "property", key: string): string {
  const escapedKey = key.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
  const match = html.match(new RegExp(`<meta\\s+${attribute}="${escapedKey}"\\s+content="([^"]*)"[^>]*>`, "i"));
  return match?.[1]?.trim() || "";
}

function setMeta(
  html: string,
  attribute: "name" | "property",
  key: string,
  content: string
): string {
  const escapedKey = key.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
  const pattern = new RegExp(`<meta\\s+${attribute}="${escapedKey}"[^>]*>\\s*`, "gi");
  const cleaned = html.replace(pattern, "");
  return cleaned.replace(
    "</head>",
    `<meta ${attribute}="${key}" content="${content}">\n</head>`
  );
}

function normalizeMetaText(value: string): string {
  return value.replace(/\s+/g, " ").trim();
}

function pageDescription(relativePath: string, title: string, current: string): string {
  if (relativePath === "index.html") return SITE_DESCRIPTION;
  if (current && !GENERIC_DESCRIPTIONS.has(current)) return current;

  const pageTitle = title
    .replace(/\s+[–—-]\s+R 语言学习笔记$/u, "")
    .trim();
  return `${pageTitle}中文教程，系统梳理核心概念、适用场景、操作方法与实践要点，便于学习、查阅和实际应用。`;
}

function lightweightControls(assetPrefix: string): string {
  return `<!-- Lightweight global controls; behavior lives in one cacheable deferred script. -->
<button id="back-to-top" type="button" aria-label="返回顶部">
  <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
    <path d="M18 15l-6-6-6 6"></path>
  </svg>
</button>
<button id="toc-floating-btn" type="button" aria-label="打开目录" aria-controls="mobile-toc-dialog" aria-expanded="false">
  <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
    <line x1="8" y1="6" x2="21" y2="6"></line><line x1="8" y1="12" x2="21" y2="12"></line><line x1="8" y1="18" x2="21" y2="18"></line>
    <line x1="3" y1="6" x2="3.01" y2="6"></line><line x1="3" y1="12" x2="3.01" y2="12"></line><line x1="3" y1="18" x2="3.01" y2="18"></line>
  </svg>
</button>
<div class="toc-modal-overlay" id="mobile-toc-dialog">
  <div class="toc-modal-content" role="dialog" aria-modal="true" aria-labelledby="mobile-toc-title">
    <div class="toc-modal-header"><div class="toc-modal-title" id="mobile-toc-title">目录</div><button class="toc-modal-close" type="button" aria-label="关闭目录">&times;</button></div>
    <div class="toc-modal-body" id="toc-modal-body"></div>
  </div>
</div>
<script src="${assetPrefix}site-interactions.js?v=20260731" defer></script>
`;
}

async function upgradePublishedHtml(): Promise<void> {
  const htmlFiles = listHtmlFiles(outputDir);
  const stylesDigest = new Uint8Array(
    await crypto.subtle.digest("SHA-256", Deno.readFileSync(`${outputDir}/styles.css`))
  );
  const stylesVersion = Array.from(stylesDigest.slice(0, 8), (byte) =>
    byte.toString(16).padStart(2, "0")
  ).join("");
  let footerUpgrades = 0;

  for (const filePath of htmlFiles) {
    const relativePath = filePath.slice(outputDir.length + 1).replaceAll("\\", "/");
    const depth = relativePath.split("/").length - 1;
    const assetPrefix = depth ? "../".repeat(depth) : "./";
    const canonicalPath = CANONICAL_ALIASES.get(relativePath) ??
      (relativePath === "index.html" ? "" : relativePath);
    const canonicalUrl = new URL(canonicalPath, SITE_URL).href;
    let html = Deno.readTextFileSync(filePath);

    const legacyStart = html.indexOf("<!-- Back to Top Button -->");
    const loaderComment = legacyStart >= 0 ? html.indexOf("// 智能检测路径", legacyStart) : -1;
    const dynamicLoaderStart = loaderComment >= 0 ? html.lastIndexOf("<script", loaderComment) : -1;
    const directLoaderCandidates = legacyStart >= 0
      ? [
          html.indexOf('<script src="./custom-sidebar.js', legacyStart),
          html.indexOf('<script src="../custom-sidebar.js', legacyStart),
          html.indexOf('<script id="quarto-html-after-body"', legacyStart)
        ].filter((position) => position >= 0)
      : [];
    const legacyEnd = dynamicLoaderStart >= 0
      ? dynamicLoaderStart
      : (directLoaderCandidates.length ? Math.min(...directLoaderCandidates) : -1);
    if (legacyStart >= 0 && legacyEnd > legacyStart) {
      html = html.slice(0, legacyStart) + lightweightControls(assetPrefix) + html.slice(legacyEnd);
      footerUpgrades++;
    }

    html = html.replace(
      /(\bhref=["'](?:\.\.?\/)*styles\.css)(?:\?v=[^"']*)?(["'])/g,
      `$1?v=${stylesVersion}$2`
    );

    const title = normalizeMetaText(
      html.match(/<title>([\s\S]*?)<\/title>/i)?.[1] || SITE_NAME
    );
    const descriptions = [...html.matchAll(/<meta\s+name="description"\s+content="([^"]*)"[^>]*>\s*/gi)];
    const normalDescription = normalizeMetaText(descriptions[0]?.[1] || "");
    const socialDescription = metaContent(html, "property", "og:description");
    const existingDescription = normalizeMetaText(normalDescription || socialDescription);
    const description = pageDescription(relativePath, title, existingDescription);

    html = html.replace(/<meta\s+name="description"[^>]*>\s*/gi, "");
    html = setMeta(html, "name", "description", description);

    html = html.replace(/<link\s+rel="canonical"[^>]*>\s*/gi, "");
    html = html.replace("</head>", `<link rel="canonical" href="${canonicalUrl}">\n</head>`);

    const isArticle = relativePath !== "index.html" && !relativePath.startsWith("sections/");
    html = setMeta(html, "property", "og:type", isArticle ? "article" : "website");
    html = setMeta(html, "property", "og:url", canonicalUrl);
    html = setMeta(html, "property", "og:title", title);
    html = setMeta(html, "property", "og:description", description);
    html = setMeta(html, "property", "og:site_name", SITE_NAME);
    html = setMeta(html, "property", "og:locale", "zh_CN");
    if (!metaContent(html, "property", "og:image")) {
      html = setMeta(html, "property", "og:image", `${SITE_URL}images/og-image.svg`);
    }

    // Older generated pages used property="twitter:*". Keep one standard name="twitter:*" set.
    html = html.replace(/<meta\s+property="twitter:[^"]+"[^>]*>\s*/gi, "");
    html = setMeta(html, "name", "twitter:url", canonicalUrl);
    html = setMeta(html, "name", "twitter:title", title);
    html = setMeta(html, "name", "twitter:description", description);
    html = setMeta(html, "name", "twitter:card", "summary_large_image");
    if (!metaContent(html, "name", "twitter:image")) {
      html = setMeta(html, "name", "twitter:image", `${SITE_URL}images/og-image.svg`);
    }

    html = html.replace(
      /<script type="application\/ld\+json">[\s\S]*?"@type"\s*:\s*"WebSite"[\s\S]*?<\/script>\s*/gi,
      ""
    );
    const jsonLd = `<script type="application/ld+json">
{"@context":"https://schema.org","@type":"WebSite","name":"${SITE_NAME}","url":"${SITE_URL}","description":"${SITE_DESCRIPTION}","inLanguage":"zh-CN"}
</script>\n`;
    html = html.replace("</head>", `${jsonLd}</head>`);

    if (NOINDEX_HTML.has(relativePath)) {
      html = setMeta(html, "name", "robots", "noindex, nofollow");
    } else {
      html = html.replace(/<meta\s+name="robots"[^>]*>\s*/gi, "");
    }

    html = html.replace(/[ \t]+(?=\r?\n)/g, "");
    Deno.writeTextFileSync(filePath, html);
  }

  if (Deno.env.get("QUARTO_PROJECT_SCRIPT_QUIET") !== "1") {
    console.log(`Published HTML: ${htmlFiles.length} pages normalized; ${footerUpgrades} legacy inline footers replaced.`);
  }
}

function xmlEscape(value: string): string {
  return value
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&apos;");
}

function buildSitemap(): void {
  const urls = listHtmlFiles(outputDir)
    .map((path) => path.slice(outputDir.length + 1).replaceAll("\\", "/"))
    .filter((path) => !NOINDEX_HTML.has(path) && !CANONICAL_ALIASES.has(path))
    .map((path) => path === "index.html" ? "" : path)
    .sort((left, right) => left.localeCompare(right, "en"))
    .map((path) => new URL(path, SITE_URL).href);

  const body = urls.map((url) => `  <url><loc>${xmlEscape(url)}</loc></url>`).join("\n");
  const xml = `<?xml version="1.0" encoding="UTF-8"?>\n` +
    `<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n${body}\n</urlset>\n`;
  Deno.writeTextFileSync(`${outputDir}/sitemap.xml`, xml);

  if (Deno.env.get("QUARTO_PROJECT_SCRIPT_QUIET") !== "1") {
    console.log(`Sitemap: ${urls.length} canonical HTML URLs.`);
  }
}

await upgradePublishedHtml();
optimizeSearchIndex();
buildSitemap();
