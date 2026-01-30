# 统计教程质量检查清单

## 1. 生成前确认
- [ ] 明确研究问题类型 (描述/关联/预测/因果)?
- [ ] 确定数据结构 (横断面/面板/嵌套/生存)?
- [ ] 选定核心 R 包 (如 survival, MatchIt, lme4)?

## 2. 内容完整性验证
- [ ] 是否包含"零基础通俗解释"?
- [ ] 是否列出了所有模型假设及检验方法?
- [ ] 代码是否包含逐行注释?
- [ ] 结果解读是否包含效应量 (OR/HR/β) 和 95% CI?

## 3. 导航系统更新 (CRITICAL)
- [ ] **Step 1**: `doc/_quarto.yml` 已添加新条目 (缩进 14 空格)。
- [ ] **Step 2**: 已运行 `Rscript generate_sections.R`。
- [ ] **Step 3**: `sections/statistics.qmd` 已出现新文章链接。
- [ ] **Step 4**: `doc/0001-guide.rmd` 已更新表格。

## 4. 视觉资产验证
- [ ] 封面图 `images/[topic]-cover.svg` 已生成。
- [ ] 复杂的原理部分是否已补充 `images/diagrams/` 示意图?
- [ ] SVG 标注是否全部使用中文?
