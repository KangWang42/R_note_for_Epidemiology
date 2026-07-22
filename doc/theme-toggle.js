/**
 * 轻量主题切换器。首帧主题由页头脚本设置，此文件负责按钮与后续交互。
 */
(function () {
  'use strict';

  var THEME_KEY = 'r-notes-theme';
  var media = window.matchMedia
    ? window.matchMedia('(prefers-color-scheme: dark)')
    : null;

  function savedTheme() {
    try {
      return localStorage.getItem(THEME_KEY);
    } catch (_) {
      return null;
    }
  }

  function preferredTheme() {
    return savedTheme() || (media && media.matches ? 'dark' : 'light');
  }

  function applyTheme(theme, persist) {
    var dark = theme === 'dark';
    var html = document.documentElement;
    var body = document.body;

    html.toggleAttribute('data-theme', dark);
    if (dark) html.setAttribute('data-theme', 'dark');
    html.setAttribute('data-bs-theme', dark ? 'dark' : 'light');
    html.classList.toggle('quarto-dark', dark);
    html.classList.toggle('quarto-light', !dark);

    if (body) {
      body.classList.toggle('quarto-dark', dark);
      body.classList.toggle('quarto-light', !dark);
    }

    if (persist) {
      try {
        localStorage.setItem(THEME_KEY, theme);
      } catch (_) {
        /* 页面仍可使用当前主题。 */
      }
    }
  }

  function createButton() {
    if (document.getElementById('theme-toggle')) return;

    var button = document.createElement('button');
    button.id = 'theme-toggle';
    button.type = 'button';
    button.setAttribute('aria-label', '切换日间或夜间模式');
    button.setAttribute('title', '切换日间或夜间模式');
    button.innerHTML =
      '<svg class="icon-moon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"></path></svg>' +
      '<svg class="icon-sun" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="12" cy="12" r="5"></circle><line x1="12" y1="1" x2="12" y2="3"></line><line x1="12" y1="21" x2="12" y2="23"></line><line x1="4.22" y1="4.22" x2="5.64" y2="5.64"></line><line x1="18.36" y1="18.36" x2="19.78" y2="19.78"></line><line x1="1" y1="12" x2="3" y2="12"></line><line x1="21" y1="12" x2="23" y2="12"></line><line x1="4.22" y1="19.78" x2="5.64" y2="18.36"></line><line x1="18.36" y1="5.64" x2="19.78" y2="4.22"></line></svg>';

    button.addEventListener('click', function () {
      var next = document.documentElement.hasAttribute('data-theme')
        ? 'light'
        : 'dark';
      applyTheme(next, true);
    });
    document.body.appendChild(button);
  }

  applyTheme(preferredTheme(), false);
  createButton();

  if (media) {
    var handleSystemTheme = function (event) {
      if (!savedTheme()) applyTheme(event.matches ? 'dark' : 'light', false);
    };

    if (typeof media.addEventListener === 'function') {
      media.addEventListener('change', handleSystemTheme);
    } else if (typeof media.addListener === 'function') {
      media.addListener(handleSystemTheme);
    }
  }
})();
