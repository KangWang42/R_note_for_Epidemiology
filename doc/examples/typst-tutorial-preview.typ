#set page(
  width: 180mm,
  height: 120mm,
  margin: (x: 15mm, y: 13mm),
  fill: rgb("fbfaf7"),
)

#set text(
  font: "Microsoft YaHei",
  lang: "zh",
  size: 9.5pt,
  fill: rgb("252525"),
)

#set par(justify: true, leading: 0.7em)
#set heading(numbering: "1.1")
#set math.equation(numbering: "(1)")

#show heading.where(level: 1): it => block(
  below: 0.8em,
  breakable: false,
)[
  #set text(size: 18pt, weight: "bold", fill: rgb("2f596d"))
  #it
]

#let note(title: [方法提示], body) = block(
  width: 100%,
  fill: rgb("eef3f4"),
  stroke: (left: 2.2pt + rgb("b85c3f")),
  inset: (x: 9pt, y: 7pt),
  radius: 2pt,
)[
  *#title* #h(0.5em) #body
]

= 队列研究分析摘要

#grid(
  columns: (1.2fr, 0.8fr),
  gutter: 12pt,
  [
    本页演示 Typst 的页面设置、标题样式、公式、提示框、表格与交叉引用。样式集中定义后，正文只保留内容和结构。

    $ hat(beta) = (X^T X)^(-1) X^T y $ <eq-model>

    @eq-model 给出线性模型的最小二乘估计。

    #note[排版系统负责呈现，不负责核验统计结论。分析数字应来自可追溯的数据与代码。]
  ],
  [
    #figure(
      table(
        columns: (1.25fr, 0.8fr, 0.8fr),
        align: (left, right, right),
        stroke: none,
        inset: (x: 5pt, y: 4pt),
        fill: (_, row) => if row == 0 { rgb("2f596d") } else if calc.odd(row) { rgb("f0eee8") },
        table.hline(stroke: 0.7pt + rgb("2f596d")),
        text(fill: white, weight: "bold")[变量],
        text(fill: white, weight: "bold")[均值],
        text(fill: white, weight: "bold")[标准差],
        [年龄（岁）], [56.2], [8.4],
        [BMI], [24.1], [3.7],
        [收缩压], [128.6], [15.2],
        table.hline(stroke: 0.7pt + rgb("2f596d")),
      ),
      caption: [示例基线特征],
    ) <tab-baseline>

    @tab-baseline 的题注和编号由 Typst 自动管理。
  ],
)

#v(0.5em)
#line(length: 100%, stroke: 0.5pt + rgb("b9b6ad"))
#set text(size: 7.5pt, fill: rgb("666666"))
示例输出 · Typst 0.13 兼容语法 · 数据仅用于排版演示
