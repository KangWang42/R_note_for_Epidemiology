/**
 * 全站轻量导航增强。
 * 仅处理首页分页、侧栏清理和移动目录可访问性。
 */
(function () {
  'use strict';

  function enhanceHomeListingPagination() {
    if (!document.body || !document.body.classList.contains('home-page')) return;

    var listing = document.querySelector('#listing-home-latest');
    if (!listing) return;

    var wrapper = listing.querySelector('.listing-pagination');
    if (!wrapper) {
      wrapper = document.createElement('nav');
      wrapper.className = 'listing-pagination home-listing-pagination';
      wrapper.innerHTML = '<ul class="pagination"></ul>';
      listing.appendChild(wrapper);
    }

    wrapper.classList.add('home-listing-pagination');
    wrapper.setAttribute('aria-label', '教程分页');
    wrapper.removeAttribute('aria-hidden');

    listing.addEventListener('click', function (event) {
      var pageLink = event.target.closest('.home-listing-pagination .page-link');
      if (!pageLink) return;

      event.preventDefault();
      window.setTimeout(function () {
        var heading = document.querySelector('.home-latest-heading');
        if (!heading) return;

        window.requestAnimationFrame(function () {
          window.requestAnimationFrame(function () {
            var top = heading.getBoundingClientRect().top + window.scrollY - 96;
            var root = document.documentElement;
            var previousScrollBehavior = root.style.scrollBehavior;
            root.style.scrollBehavior = 'auto';
            window.scrollTo(0, Math.max(0, top));
            window.requestAnimationFrame(function () {
              root.style.scrollBehavior = previousScrollBehavior;
            });
          });
        });
      }, 0);
    }, true);
  }

  function enhanceHomeTaskNavigation() {
    var button = document.querySelector('.home-task-toggle');
    var links = document.getElementById('home-task-links');
    if (!button || !links) return;

    var mobileQuery = window.matchMedia('(max-width: 767px)');

    function setExpanded(expanded) {
      links.hidden = !expanded;
      button.setAttribute('aria-expanded', expanded ? 'true' : 'false');
      button.textContent = expanded ? '收起' : '展开';
    }

    function syncForViewport(event) {
      setExpanded(!event.matches);
    }

    button.addEventListener('click', function () {
      setExpanded(button.getAttribute('aria-expanded') !== 'true');
    });

    if (typeof mobileQuery.addEventListener === 'function') {
      mobileQuery.addEventListener('change', syncForViewport);
    } else {
      mobileQuery.addListener(syncForViewport);
    }

    syncForViewport(mobileQuery);
  }

  function removeDecorativeEmoji() {
    var emojiPrefix = /^[\u2600-\u27BF\u{1F000}-\u{1FAFF}\uFE0F\u200D]+\s*/u;

    document.querySelectorAll('#quarto-sidebar .menu-text').forEach(function (label) {
      var cleaned = label.textContent.replace(emojiPrefix, '').trim();
      if (cleaned && cleaned !== label.textContent.trim()) {
        label.textContent = cleaned;
      }
    });
  }

  function collapseInactiveSections() {
    var sidebar = document.querySelector('#quarto-sidebar');
    if (!sidebar) return;

    var topSections = sidebar.querySelectorAll(
      ':scope > .sidebar-menu-container > ul > li.sidebar-item-section'
    );

    topSections.forEach(function (section) {
      var panel = section.querySelector(':scope > ul.sidebar-section');
      if (!panel || section.querySelector('a.active')) return;

      panel.classList.remove('show');
      section
        .querySelectorAll(':scope > .sidebar-item-container [data-bs-toggle="collapse"]')
        .forEach(function (toggle) {
          toggle.classList.add('collapsed');
          toggle.setAttribute('aria-expanded', 'false');
        });
    });
  }

  function enhanceMobileToc() {
    var button = document.getElementById('toc-floating-btn');
    var overlay = document.querySelector('.toc-modal-overlay');
    var closeButton = document.querySelector('.toc-modal-close');
    var panel = document.querySelector('.toc-modal-content');
    var mobileDock = document.querySelector('.quarto-secondary-nav .container-fluid');

    if (!button || !overlay || !panel) return;

    if (mobileDock && window.matchMedia('(max-width: 991.98px)').matches) {
      button.classList.add('toc-nav-docked');
      mobileDock.appendChild(button);
    }

    if (!overlay.id) overlay.id = 'mobile-toc-dialog';
    panel.setAttribute('role', 'dialog');
    panel.setAttribute('aria-modal', 'true');
    panel.setAttribute('aria-labelledby', 'mobile-toc-title');

    var title = panel.querySelector('.toc-modal-title');
    if (title) title.id = 'mobile-toc-title';

    button.setAttribute('aria-controls', overlay.id);
    button.setAttribute('aria-expanded', 'false');

    function syncState() {
      var open = overlay.classList.contains('active');
      button.setAttribute('aria-expanded', open ? 'true' : 'false');
      document.body.classList.toggle('toc-modal-open', open);
      if (open && closeButton) closeButton.focus({ preventScroll: true });
    }

    function closeToc() {
      if (!overlay.classList.contains('active')) return;
      overlay.classList.remove('active');
      syncState();
      button.focus({ preventScroll: true });
    }

    var observer = new MutationObserver(syncState);
    observer.observe(overlay, { attributes: true, attributeFilter: ['class'] });

    document.addEventListener('keydown', function (event) {
      if (event.key === 'Escape') closeToc();
    });

    window.addEventListener(
      'resize',
      function () {
        if (window.innerWidth >= 1200) closeToc();
      },
      { passive: true }
    );
  }

  function init() {
    enhanceHomeTaskNavigation();
    removeDecorativeEmoji();
    collapseInactiveSections();
    enhanceMobileToc();
  }

  enhanceHomeListingPagination();

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init, { once: true });
  } else {
    init();
  }
})();
