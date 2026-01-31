# 自定义侧边栏实现说明

## 📁 文件结构

```
doc/
├── custom-sidebar.js          # 侧边栏 JavaScript 逻辑
├── custom-sidebar.css         # 侧边栏样式
├── custom-sidebar-loader.html # 智能脚本加载器
└── _quarto.yml                # Quarto 配置（已更新）
```

## 🔧 工作原理

### 1. JavaScript 加载流程

```
页面加载
  ↓
custom-sidebar-loader.html 执行
  ↓
检测当前页面路径
  ├─ 如果是 /sections/ 页面 → 加载 ../custom-sidebar.js
  └─ 如果是根目录页面    → 加载 custom-sidebar.js
  ↓
custom-sidebar.js 初始化
  ↓
等待 window.searchData 加载完成
  ↓
调用 initializeSidebar()
  ↓
渲染侧边栏卡片（学习路径、本周必学、精选教程）
```

### 2. CSS 加载

- Quarto 自动处理 CSS 路径
- `custom-sidebar.css` 在 `_quarto.yml` 中全局引用
- 自动为 sections 页面生成 `../custom-sidebar.css`

### 3. 侧边栏内容

#### 学习路径卡片
- 入门：从零开始学 R
- 进阶：掌握实用 R 包
- 高级：统计建模分析

#### 本周必学卡片
- 学习路线规划
- ggplot2 可视化入门
- dplyr 数据处理
- Logistic 回归

#### 精选教程卡片
- 从 `window.searchData` 随机选取 3 篇教程
- 显示标签（热门/推荐/精选/必读）
- 显示难度（星级）
- 支持刷新按钮换一批

## 🎨 样式特性

- ✅ 响应式设计（移动端自动隐藏）
- ✅ 暗色模式适配
- ✅ 悬停动画效果
- ✅ 卡片阴影与边框
- ✅ 图标与徽章系统

## 🔄 更新方法

### 修改侧边栏内容

编辑 `doc/custom-sidebar.js`：

```javascript
// 修改本周必学卡片
const essentialTopics = [
  { title: '新教程标题', href: 'new-tutorial.html', tag: '新标签', icon: 'bi bi-icon' },
  // ... 其他项目
];
```

### 修改侧边栏样式

编辑 `doc/custom-sidebar.css`：

```css
.sidebar-card {
  background: #your-color;
  /* 其他样式 */
}
```

## 🧪 测试

### 验证侧边栏是否加载

在浏览器控制台运行：

```javascript
// 检查脚本是否加载
console.log('Sidebar initialized:', window.sidebarInitialized);

// 检查数据是否可用
console.log('SearchData available:', !!window.searchData);

// 检查DOM元素
console.log('Sidebar exists:', !!document.querySelector('.custom-sidebar-cards'));
```

### 调试模式

取消 `custom-sidebar.js` 中的 DEBUG 注释：

```javascript
// 修改前
// DEBUG: console.log('[侧边栏] DOMContentLoaded 触发');

// 修改后
console.log('[侧边栏] DOMContentLoaded 触发');
```

## 📝 注意事项

1. **路径解析**: `isSectionPage` 变量自动检测页面是否在 `/sections/` 目录
2. **数据依赖**: 侧边栏依赖 Quarto 的 `window.searchData` 
3. **初始化保护**: `sidebarInitialized` 标志防止重复初始化
4. **轮询机制**: 如果 searchData 未立即可用，每100ms检查一次，最多等待5秒

## 🚀 部署

渲染整个网站：

```bash
cd doc
quarto render
```

只渲染特定页面：

```bash
cd doc
quarto render index.qmd
quarto render sections/statistics.qmd
```

---

**更新时间**: 2026-01-31  
**维护者**: AI Assistant
