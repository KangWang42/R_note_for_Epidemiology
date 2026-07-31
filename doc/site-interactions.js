(() => {
  "use strict";

  const SUPABASE_URL = "https://zyfdzyifhvglibpganxt.supabase.co";
  const SUPABASE_ANON_KEY = "sb_publishable_XhaP4hFZ30sHZybEjVRQxg_iwlPTxz8";

  const safeStorage = {
    get(key) {
      try {
        return window.localStorage.getItem(key);
      } catch (_) {
        return null;
      }
    },
    set(key, value) {
      try {
        window.localStorage.setItem(key, value);
      } catch (_) {
        // The page remains usable when storage is unavailable.
      }
    }
  };

  const scheduleIdle = (callback) => {
    if ("requestIdleCallback" in window) {
      window.requestIdleCallback(callback, { timeout: 1500 });
    } else {
      window.setTimeout(callback, 1);
    }
  };

  const isArticlePage = () => {
    const path = window.location.pathname;
    return !document.body.classList.contains("home-page") &&
      !path.includes("/sections/") &&
      !path.endsWith("/") &&
      !path.endsWith("/index.html");
  };

  function initBackToTop() {
    const button = document.getElementById("back-to-top");
    if (!button) return;

    let updateQueued = false;
    const update = () => {
      button.classList.toggle("visible", window.scrollY > 300);
      updateQueued = false;
    };

    window.addEventListener("scroll", () => {
      if (!updateQueued) {
        updateQueued = true;
        window.requestAnimationFrame(update);
      }
    }, { passive: true });

    button.addEventListener("click", () => {
      window.scrollTo({ top: 0, behavior: "smooth" });
    });
  }

  function initMobileToc() {
    const button = document.getElementById("toc-floating-btn");
    const overlay = document.getElementById("mobile-toc-dialog");
    const closeButton = overlay?.querySelector(".toc-modal-close");
    const modalBody = document.getElementById("toc-modal-body");
    const originalToc = document.getElementById("TOC");
    const dock = document.querySelector(".quarto-secondary-nav .container-fluid");

    if (!button || !overlay || !closeButton || !modalBody || !originalToc) {
      if (button) button.style.display = "none";
      return;
    }

    const tocList = originalToc.querySelector("ul");
    if (!tocList || !originalToc.querySelector("a")) {
      button.style.display = "none";
      return;
    }

    if (dock && window.matchMedia("(max-width: 991.98px)").matches) {
      button.classList.add("toc-nav-docked");
      dock.appendChild(button);
    }
    button.style.display = "flex";

    let populated = false;
    const close = () => {
      overlay.classList.remove("active");
      document.body.classList.remove("toc-modal-open");
      button.setAttribute("aria-expanded", "false");
    };

    button.addEventListener("click", () => {
      if (!populated) {
        const clone = tocList.cloneNode(true);
        clone.querySelectorAll("a").forEach((link) => link.addEventListener("click", close));
        modalBody.appendChild(clone);
        populated = true;
      }
      overlay.classList.add("active");
      document.body.classList.add("toc-modal-open");
      button.setAttribute("aria-expanded", "true");
      closeButton.focus();
    });

    closeButton.addEventListener("click", close);
    overlay.addEventListener("click", (event) => {
      if (event.target === overlay) close();
    });
    document.addEventListener("keydown", (event) => {
      if (event.key === "Escape" && overlay.classList.contains("active")) close();
    });
  }

  function wrapWideTables() {
    if (!window.matchMedia("(max-width: 991.98px)").matches) return;
    document.querySelectorAll("main table").forEach((table) => {
      if (table.parentElement?.classList.contains("table-responsive")) return;
      const wrapper = document.createElement("div");
      wrapper.className = "table-responsive";
      table.before(wrapper);
      wrapper.appendChild(table);
    });
  }

  function appendArticleNavigation(mainContent) {
    const sidebar = document.querySelector("#quarto-sidebar") || document.querySelector(".sidebar");
    if (!sidebar) return;

    const preferredLinks = [...sidebar.querySelectorAll("a.sidebar-item-text")];
    const candidates = preferredLinks.length ? preferredLinks : [...sidebar.querySelectorAll("a")];
    const links = candidates.filter((link) =>
      link.href && !link.href.endsWith("#") && !link.href.startsWith("javascript:")
    );
    if (!links.length) return;

    const currentUrl = window.location.href.split("#")[0];
    const currentIndex = links.findIndex((link) => link.href.split("#")[0] === currentUrl);
    const container = document.createElement("div");
    container.className = "article-footer-nav-container";

    const createLink = (source, label, suffix, alignRight = false) => {
      const link = document.createElement("a");
      link.className = "article-nav-link";
      link.href = source.href;
      if (alignRight) link.classList.add("article-nav-link-next");

      const labelNode = document.createElement("span");
      labelNode.className = "nav-label";
      labelNode.textContent = label;
      const titleNode = document.createElement("span");
      titleNode.className = "nav-title";
      titleNode.textContent = `${suffix.before || ""}${source.textContent.trim()}${suffix.after || ""}`;
      link.append(labelNode, titleNode);
      return link;
    };

    if (currentIndex !== -1) {
      const navigation = document.createElement("div");
      navigation.className = "article-footer-nav";
      if (currentIndex > 0) {
        navigation.appendChild(createLink(links[currentIndex - 1], "上一篇", { before: "« " }));
      } else {
        navigation.appendChild(document.createElement("div"));
      }
      if (currentIndex < links.length - 1) {
        navigation.appendChild(createLink(links[currentIndex + 1], "下一篇", { after: " »" }, true));
      } else {
        navigation.appendChild(document.createElement("div"));
      }
      container.appendChild(navigation);
    }

    const alternatives = links.filter((_, index) => index !== currentIndex);
    const recommendation = alternatives[Math.floor(Math.random() * alternatives.length)];
    if (recommendation?.textContent.trim()) {
      const block = document.createElement("div");
      block.className = "random-recommendation";
      const title = document.createElement("h4");
      title.textContent = "随便看看";
      const description = document.createElement("p");
      description.textContent = "探索更多 R 语言教程";
      const link = document.createElement("a");
      link.className = "random-btn";
      link.href = recommendation.href;
      link.textContent = recommendation.textContent.trim();
      block.append(title, description, link);
      container.appendChild(block);
    }

    mainContent.appendChild(container);
  }

  async function supabaseRequest(method, endpoint, body = null) {
    const options = {
      method,
      headers: {
        apikey: SUPABASE_ANON_KEY,
        Authorization: `Bearer ${SUPABASE_ANON_KEY}`,
        "Content-Type": "application/json",
        Prefer: method === "POST" ? "return=representation" : "return=minimal"
      }
    };
    if (body) options.body = JSON.stringify(body);

    const response = await fetch(`${SUPABASE_URL}/rest/v1/${endpoint}`, options);
    if (!response.ok) throw new Error(`HTTP ${response.status}`);
    const text = await response.text();
    return text ? JSON.parse(text) : null;
  }

  function initArticleInteractions(mainContent) {
    const articleId = window.location.pathname.replace(/[^a-zA-Z0-9]/g, "_");
    const likeKey = `article_like_${articleId}`;
    const initiallyLiked = safeStorage.get(likeKey) === "true";
    let likeCount = 0;
    let hydrationPromise = null;

    const likeSection = document.createElement("section");
    likeSection.className = "article-like-section";
    likeSection.setAttribute("aria-label", "文章反馈");
    likeSection.innerHTML = `
      <div class="like-section-inner">
        <p class="like-prompt">觉得有帮助？欢迎点赞支持。</p>
        <button type="button" class="like-btn${initiallyLiked ? " liked" : ""}" id="article-like-btn"
          aria-label="点赞" aria-pressed="${initiallyLiked}">
          <svg class="like-icon" viewBox="0 0 24 24" aria-hidden="true">
            <path class="heart-outline" d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/>
            <path class="heart-fill" d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/>
          </svg>
          <span class="like-text">${initiallyLiked ? "已喜欢" : "喜欢这篇文章"}</span>
          <span class="like-count" id="like-count" aria-live="polite"></span>
        </button>
      </div>`;

    const commentSection = document.createElement("section");
    commentSection.className = "comment-section";
    commentSection.setAttribute("aria-labelledby", "comment-title");
    commentSection.innerHTML = `
      <h4 class="comment-title" id="comment-title">评论区</h4>
      <div class="comment-form">
        <label class="visually-hidden" for="comment-nickname">昵称（可选）</label>
        <input type="text" id="comment-nickname" class="comment-nickname" placeholder="昵称（可选）" maxlength="20">
        <label class="visually-hidden" for="comment-content">评论内容</label>
        <textarea id="comment-content" class="comment-textarea" placeholder="写下你的想法..." maxlength="500" rows="3"></textarea>
        <div class="comment-form-footer">
          <span class="char-count"><span id="char-count">0</span>/500</span>
          <button type="button" id="submit-comment" class="comment-submit-btn">发表评论</button>
        </div>
      </div>
      <div id="comment-list" class="comment-list" aria-live="polite">
        <div class="loading-comments">滚动至评论区时加载评论。</div>
      </div>`;

    mainContent.append(likeSection, commentSection);

    const likeButton = likeSection.querySelector(".like-btn");
    const likeCountNode = likeSection.querySelector(".like-count");
    const likeText = likeSection.querySelector(".like-text");
    const nicknameInput = commentSection.querySelector(".comment-nickname");
    const contentInput = commentSection.querySelector(".comment-textarea");
    const submitButton = commentSection.querySelector(".comment-submit-btn");
    const commentList = commentSection.querySelector(".comment-list");
    const characterCount = commentSection.querySelector("#char-count");

    let visitorId = safeStorage.get("visitor_id");
    if (!visitorId) {
      visitorId = `v_${Math.random().toString(36).slice(2, 11)}${Date.now().toString(36)}`;
      safeStorage.set("visitor_id", visitorId);
    }

    const formatTime = (timestamp) => {
      const date = new Date(timestamp);
      const difference = Date.now() - date.getTime();
      if (difference < 60000) return "刚刚";
      if (difference < 3600000) return `${Math.floor(difference / 60000)} 分钟前`;
      if (difference < 86400000) return `${Math.floor(difference / 3600000)} 小时前`;
      if (difference < 604800000) return `${Math.floor(difference / 86400000)} 天前`;
      return date.toLocaleDateString("zh-CN");
    };

    const fetchLikeCount = async () => {
      const data = await supabaseRequest("GET", `article_likes?article_id=eq.${articleId}&select=like_count`);
      likeCount = data?.[0]?.like_count || 0;
      likeCountNode.textContent = likeCount > 0 ? String(likeCount) : "";
    };

    const updateLikeCount = async () => {
      const existing = await supabaseRequest("GET", `article_likes?article_id=eq.${articleId}&select=id`);
      if (existing?.length) {
        await supabaseRequest("PATCH", `article_likes?article_id=eq.${articleId}`, { like_count: likeCount });
      } else {
        await supabaseRequest("POST", "article_likes", { article_id: articleId, like_count: likeCount });
      }
    };

    const deleteComment = async (commentId) => {
      await supabaseRequest(
        "DELETE",
        `article_comments?id=eq.${encodeURIComponent(commentId)}&visitor_id=eq.${encodeURIComponent(visitorId)}`
      );
    };

    const renderComments = (comments) => {
      commentList.replaceChildren();
      if (!comments?.length) {
        const empty = document.createElement("div");
        empty.className = "no-comments";
        empty.textContent = "暂无评论，欢迎留下第一条评论。";
        commentList.appendChild(empty);
        return;
      }

      comments.forEach((comment) => {
        const item = document.createElement("article");
        item.className = "comment-item";
        const header = document.createElement("div");
        header.className = "comment-header";
        const author = document.createElement("span");
        author.className = "comment-author";
        author.textContent = comment.nickname || "匿名用户";
        const time = document.createElement("time");
        time.className = "comment-time";
        time.dateTime = comment.created_at;
        time.textContent = formatTime(comment.created_at);
        header.append(author, time);

        if (comment.visitor_id === visitorId) {
          const deleteButton = document.createElement("button");
          deleteButton.type = "button";
          deleteButton.className = "comment-delete";
          deleteButton.textContent = "删除";
          deleteButton.addEventListener("click", async () => {
            deleteButton.disabled = true;
            try {
              await deleteComment(comment.id);
              await loadComments();
            } catch (_) {
              deleteButton.disabled = false;
              window.alert("删除失败，请稍后重试");
            }
          });
          header.appendChild(deleteButton);
        }

        const body = document.createElement("div");
        body.className = "comment-body";
        body.textContent = comment.content;
        item.append(header, body);
        commentList.appendChild(item);
      });
    };

    const loadComments = async () => {
      const data = await supabaseRequest(
        "GET",
        `article_comments?article_id=eq.${articleId}&order=created_at.desc`
      );
      renderComments(data || []);
    };

    const ensureHydrated = () => {
      if (!hydrationPromise) {
        commentList.innerHTML = '<div class="loading-comments">加载评论中...</div>';
        hydrationPromise = Promise.allSettled([fetchLikeCount(), loadComments()]).then((results) => {
          if (results[0].status === "rejected") likeCountNode.textContent = "";
          if (results[1].status === "rejected") {
            commentList.innerHTML = '<div class="no-comments">评论暂时无法加载，请稍后重试。</div>';
          }
        });
      }
      return hydrationPromise;
    };

    likeButton.addEventListener("click", async () => {
      likeButton.disabled = true;
      await ensureHydrated();
      const wasLiked = likeButton.classList.contains("liked");
      likeButton.classList.toggle("liked", !wasLiked);
      likeButton.setAttribute("aria-pressed", String(!wasLiked));
      likeText.textContent = wasLiked ? "喜欢这篇文章" : "已喜欢";
      likeCount = Math.max(0, likeCount + (wasLiked ? -1 : 1));
      likeCountNode.textContent = likeCount > 0 ? String(likeCount) : "";
      safeStorage.set(likeKey, String(!wasLiked));

      if (!wasLiked) {
        likeButton.classList.add("pop");
        window.setTimeout(() => likeButton.classList.remove("pop"), 300);
      }
      try {
        await updateLikeCount();
      } catch (_) {
        // Keep the local feedback usable when the network is unavailable.
      } finally {
        likeButton.disabled = false;
      }
    });

    contentInput.addEventListener("input", () => {
      characterCount.textContent = String(contentInput.value.length);
    });
    commentSection.addEventListener("focusin", ensureHydrated, { once: true });

    submitButton.addEventListener("click", async () => {
      const content = contentInput.value.trim();
      if (!content) {
        window.alert("请输入评论内容");
        return;
      }

      submitButton.disabled = true;
      submitButton.textContent = "发送中...";
      try {
        await ensureHydrated();
        await supabaseRequest("POST", "article_comments", {
          article_id: articleId,
          nickname: nicknameInput.value.trim() || "匿名用户",
          content,
          visitor_id: visitorId
        });
        contentInput.value = "";
        characterCount.textContent = "0";
        await loadComments();
      } catch (_) {
        window.alert("评论发送失败，请稍后重试");
      } finally {
        submitButton.disabled = false;
        submitButton.textContent = "发表评论";
      }
    });

    if ("IntersectionObserver" in window) {
      const observer = new IntersectionObserver((entries) => {
        if (entries.some((entry) => entry.isIntersecting)) {
          observer.disconnect();
          ensureHydrated();
        }
      }, { rootMargin: "700px 0px" });
      observer.observe(likeSection);
    }
  }

  initBackToTop();
  initMobileToc();

  const initDeferredContent = () => scheduleIdle(() => {
    wrapWideTables();
    if (!isArticlePage()) return;
    const mainContent = document.querySelector("main#quarto-document-content") || document.querySelector("main");
    if (!mainContent) return;
    appendArticleNavigation(mainContent);
    initArticleInteractions(mainContent);
  });

  if (document.readyState === "complete") {
    initDeferredContent();
  } else {
    window.addEventListener("load", initDeferredContent, { once: true });
  }
})();
