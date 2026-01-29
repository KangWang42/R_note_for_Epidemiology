/**
 * 主题切换脚本
 * 支持日间/夜间模式切换，保存用户偏好到 localStorage
 */

(function() {
  'use strict';
  
  // 主题存储键名
  const THEME_KEY = 'r-notes-theme';
  
  // 获取保存的主题或系统偏好
  function getPreferredTheme() {
    const saved = localStorage.getItem(THEME_KEY);
    if (saved) return saved;
    
    // 检测系统偏好
    if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
      return 'dark';
    }
    return 'light';
  }
  
  // 应用主题
  function setTheme(theme) {
    if (theme === 'dark') {
      document.documentElement.setAttribute('data-theme', 'dark');
    } else {
      document.documentElement.removeAttribute('data-theme');
    }
    localStorage.setItem(THEME_KEY, theme);
  }
  
  // 切换主题
  function toggleTheme() {
    const current = document.documentElement.getAttribute('data-theme');
    const newTheme = current === 'dark' ? 'light' : 'dark';
    setTheme(newTheme);
  }
  
  // 创建主题切换按钮
  function createToggleButton() {
    const btn = document.createElement('button');
    btn.id = 'theme-toggle';
    btn.setAttribute('aria-label', '切换主题');
    btn.setAttribute('title', '切换日间/夜间模式');
    
    // 月亮图标 (日间模式显示)
    const moonIcon = `<svg class="icon-moon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
      <path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"></path>
    </svg>`;
    
    // 太阳图标 (夜间模式显示)
    const sunIcon = `<svg class="icon-sun" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
      <circle cx="12" cy="12" r="5"></circle>
      <line x1="12" y1="1" x2="12" y2="3"></line>
      <line x1="12" y1="21" x2="12" y2="23"></line>
      <line x1="4.22" y1="4.22" x2="5.64" y2="5.64"></line>
      <line x1="18.36" y1="18.36" x2="19.78" y2="19.78"></line>
      <line x1="1" y1="12" x2="3" y2="12"></line>
      <line x1="21" y1="12" x2="23" y2="12"></line>
      <line x1="4.22" y1="19.78" x2="5.64" y2="18.36"></line>
      <line x1="18.36" y1="5.64" x2="19.78" y2="4.22"></line>
    </svg>`;
    
    btn.innerHTML = moonIcon + sunIcon;
    btn.addEventListener('click', toggleTheme);
    
    document.body.appendChild(btn);
  }
  
  // 监听系统主题变化
  function watchSystemTheme() {
    if (window.matchMedia) {
      window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', (e) => {
        // 仅当用户未手动设置主题时响应系统变化
        if (!localStorage.getItem(THEME_KEY)) {
          setTheme(e.matches ? 'dark' : 'light');
        }
      });
    }
  }
  
  // 初始化
  function init() {
    // 立即应用主题（避免闪烁）
    setTheme(getPreferredTheme());
    
    // DOM 加载后创建按钮
    if (document.readyState === 'loading') {
      document.addEventListener('DOMContentLoaded', createToggleButton);
    } else {
      createToggleButton();
    }
    
    // 监听系统主题
    watchSystemTheme();
  }
  
  // 立即执行
  init();
})();
