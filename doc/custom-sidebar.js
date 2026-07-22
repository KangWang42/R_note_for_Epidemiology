// Quarto 在 max-items 少于默认分页数时仍初始化分页插件，但不会输出分页容器。
// 在 DOMContentLoaded 前补充隐藏容器，避免 List.js 访问不存在的节点。
(function ensureHomeListingPagination() {
  if (!document.body || !document.body.classList.contains('home-page')) return;
  const listing = document.querySelector('#listing-listing');
  if (!listing || listing.querySelector('.pagination')) return;

  const wrapper = document.createElement('nav');
  wrapper.className = 'listing-pagination home-listing-pagination';
  wrapper.setAttribute('aria-hidden', 'true');
  wrapper.innerHTML = '<ul class="pagination"></ul>';
  listing.appendChild(wrapper);
})();

// ==================== 自定义侧边栏卡片 ====================
document.addEventListener('DOMContentLoaded', function() {
  const pagePath = window.location.pathname;
  const isHomePage = pagePath === '/' || pagePath.endsWith('/index.html') || pagePath === '';

  // 新首页使用完整宽度的信息架构，不再创建右侧随机卡片或轮询搜索数据。
  if (!isHomePage || document.body.classList.contains('home-page') || !document.querySelector('#quarto-margin-sidebar')) {
    return;
  }

  // DEBUG: console.log('[侧边栏] DOMContentLoaded 触发');
  
  // 监听 searchData 加载完成事件 - 数据加载后异步刷新精选教程
  window.addEventListener('searchDataReady', function(event) {
    // DEBUG: console.log('[侧边栏] 接收到 searchDataReady 事件, 数据量:', event.detail.data.length);
    // 数据加载后，如果侧边栏已存在，则刷新精选教程
    const featuredCard = document.querySelector('.featured');
    if (featuredCard && window.searchData && window.searchData.length > 0) {
      renderFeatured(featuredCard);
    }
  });
  
  // 立即初始化侧边栏，不等待 searchData
  initializeSidebar();
  
  // 短超时检查（仅用于刷新精选教程）
  let checkCount = 0;
  const maxChecks = 10; // 10 * 100ms = 1秒，更短的等待时间
  
  const checkDataInterval = setInterval(() => {
    checkCount++;
    
    if (window.searchData && window.searchData.length > 0 && checkCount < maxChecks) {
      // 数据加载了，停止检查
      clearInterval(checkDataInterval);
    } else if (checkCount >= maxChecks) {
      // 1秒后，如果数据已加载，刷新精选教程
      clearInterval(checkDataInterval);
      if (window.searchData && window.searchData.length > 0) {
        const featuredCard = document.querySelector('.featured');
        if (featuredCard) {
          renderFeatured(featuredCard);
        }
      }
    }
  }, 100); // 每100ms检查一次
});

// 使用 window 对象防止重复声明错误
if (typeof window.sidebarInitialized === 'undefined') {
  window.sidebarInitialized = false;
}

function initializeSidebar() {
  if (window.sidebarInitialized) {
    // DEBUG: console.log('[侧边栏] 已经初始化过,跳过');
    return;
  }
  
  // 只在首页显示自定义侧边栏，文章页面显示原始TOC
  const path = window.location.pathname;
  const isHomePage = path === '/' || path.endsWith('/index.html') || path === '';
  
  if (!isHomePage) {
    // DEBUG: console.log('[侧边栏] 非首页，跳过自定义侧边栏');
    return;
  }
  
  // 立即标记为已初始化，防止竞态条件
  window.sidebarInitialized = true;
  // DEBUG: console.log('[侧边栏] 开始初始化侧边栏...');
  
  const marginSidebar = document.querySelector('#quarto-margin-sidebar');
  if (!marginSidebar) {
    // DEBUG: console.warn('[侧边栏] 找不到 #quarto-margin-sidebar 元素');
    return;
  }

  const isSectionPage = window.location.pathname.includes('/sections/');
  const resolvePath = (path) => {
    if (isSectionPage) {
      if (!path.startsWith('sections/')) return '../' + path;
      return path.replace('sections/', '');
    }
    return path;
  };

  // 获取随机推荐(不重复)
  function getRandomItems(arr, count) {
    const shuffled = [...arr].sort(() => Math.random() - 0.5);
    return shuffled.slice(0, Math.min(count, arr.length));
  }

  // ==================== 精选教程卡片 ====================
  function renderFeatured(container) {
      // DEBUG: console.log('[精选教程] 开始渲染...');
      
      // 使用全局 filteredData 或重新过滤
      const dataToUse = window.filteredDataGlobal || window.searchData.filter(item => item && item.title && item.href && item.title.length > 0);
      // DEBUG: console.log('[精选教程] 可用数据长度:', dataToUse.length);
      
      // 动态获取推荐数据
      const items = getRandomItems(dataToUse, 3);
      // DEBUG: console.log('[精选教程] 随机选取的教程数:', items.length);
      
      // 有数据时才渲染精选教程，否则不显示
      if (items.length === 0) {
        return;
      }
      
      const cardsHtml = items.map(item => {
        const starCount = Math.floor(Math.random() * 2) + 2;
        const stars = Array(starCount).fill('<i class="bi bi-star-fill"></i>').join('');
        const tags = ['热门', '推荐', '精选', '必读'];
        const tag = tags[Math.floor(Math.random() * tags.length)];
        
        return `
        <a href="${resolvePath(item.href)}" class="featured-item">
          <div class="featured-header">
            <span class="featured-tag">${tag}</span>
            <span class="featured-difficulty">${stars}</span>
          </div>
          <div class="featured-title">${item.title}</div>
        </a>
      `}).join('');
      
      container.innerHTML = `
        <div class="sidebar-card-header">
          <span class="header-icon"><i class="bi bi-star"></i></span> 精选教程
          <span class="refresh-btn" title="换一批" id="refresh-featured"><i class="bi bi-arrow-repeat"></i></span>
        </div>
        <div class="featured-list">
          ${cardsHtml}
        </div>
      `;
      
      // DEBUG: console.log('[精选教程] 渲染完成');

      const refreshBtn = container.querySelector('#refresh-featured');
      if (refreshBtn) {
        refreshBtn.addEventListener('click', (e) => {
          e.preventDefault();
          e.stopPropagation();
          refreshBtn.style.transform = 'rotate(360deg)';
          setTimeout(() => {
            refreshBtn.style.transform = 'rotate(0deg)';
            renderFeatured(container);
          }, 300);
        });
      }
    }
    
  const customSidebarContainer = document.createElement('div');
  customSidebarContainer.className = 'custom-sidebar-cards';

  // ==================== 学习路径卡片 ====================
  const learningPathHtml = `
    <div class="sidebar-card learning-path">
      <div class="sidebar-card-header"><span class="header-icon"><i class="bi bi-compass"></i></span> 学习路径</div>
      <div class="learning-levels">
        <a href="${resolvePath('0001-guide.html')}" class="level-item level-beginner">
          <span class="level-badge">入门</span>
          <span class="level-desc">从零开始学 R</span>
        </a>
        <a href="${resolvePath('sections/packages.html')}" class="level-item level-intermediate">
          <span class="level-badge">进阶</span>
          <span class="level-desc">掌握实用 R 包</span>
        </a>
        <a href="${resolvePath('sections/statistics.html')}" class="level-item level-advanced">
          <span class="level-badge">高级</span>
          <span class="level-desc">统计建模分析</span>
        </a>
      </div>
    </div>
  `;

  // ==================== 本周必学卡片 ====================
  const essentialTopics = [
    { title: '学习路线规划', href: '0001-guide.html', tag: '必读', icon: 'bi bi-map' },
    { title: 'ggplot2 可视化入门', href: '2032-ggplot2-intro.html', tag: '基础', icon: 'bi bi-bar-chart' },
    { title: 'dplyr 数据处理', href: '3003-dplyr-tidyr.html', tag: '核心', icon: 'bi bi-wrench' },
    { title: 'Logistic 回归', href: '1019-logistic.html', tag: '统计', icon: 'bi bi-calculator' }
  ];
  
  const essentialsHtml = `
    <div class="sidebar-card essentials">
      <div class="sidebar-card-header"><span class="header-icon"><i class="bi bi-fire"></i></span> 本周必学</div>
      <div class="essentials-list">
        ${essentialTopics.map(topic => `
          <a href="${resolvePath(topic.href)}" class="essential-item">
            <span class="essential-icon"><i class="${topic.icon}"></i></span>
            <div class="essential-content">
              <div class="essential-title">${topic.title}</div>
              <span class="essential-tag">${topic.tag}</span>
            </div>
          </a>
        `).join('')}
      </div>
    </div>
  `;

  // ==================== 精选教程卡片 ====================
  const featuredCard = document.createElement('div');
  featuredCard.className = 'sidebar-card featured';
  
  // 组装所有卡片
  customSidebarContainer.innerHTML = learningPathHtml + essentialsHtml;
  customSidebarContainer.appendChild(featuredCard);
  
  // DEBUG: console.log('[侧边栏] 卡片HTML已组装');
  
  // 先将侧边栏添加到页面 (重要: 必须在更新数据之前!)
  const toc = marginSidebar.querySelector('#TOC') || marginSidebar.querySelector('nav');
  if (toc) {
    toc.after(customSidebarContainer);
    // DEBUG: console.log('[侧边栏] 已插入到 TOC 之后');
  } else {
    marginSidebar.appendChild(customSidebarContainer);
    // DEBUG: console.log('[侧边栏] 已添加到 marginSidebar');
  }
  
  // DEBUG: 验证DOM元素是否存在
  // console.log('[侧边栏] 验证DOM元素:');
  // console.log('  - stats-total:', !!document.getElementById('stats-total'));
  // console.log('  - stats-topics:', !!document.getElementById('stats-topics'));
  // console.log('  - stats-level:', !!document.getElementById('stats-level'));
  // console.log('  - count-viz:', !!document.getElementById('count-viz'));
  
  // 现在DOM已存在,可以渲染内容
  // DEBUG: console.log('[侧边栏] 开始渲染内容...');
  // DEBUG: console.log('[侧边栏] window.searchData 长度:', window.searchData ? window.searchData.length : 0);
  
  if (window.searchData && window.searchData.length > 0) {
    const currentData = window.searchData.filter(item => item && item.title && item.href && item.title.length > 0);
    // DEBUG: console.log('[侧边栏] 过滤后数据长度:', currentData.length);
    
    if (currentData.length > 0) {
      window.filteredDataGlobal = currentData;
      renderFeatured(featuredCard);
      // DEBUG: console.log('[侧边栏] 内容渲染完成!');
    }
  }
  
  // DEBUG: console.log('[侧边栏] 初始化完成!');
}
