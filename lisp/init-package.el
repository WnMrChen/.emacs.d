;;; init-package.el --- package configuration -*- lexical-binding: t; -*-

;; 如果你没有在别处设置这个，建议加上
(setq use-package-always-ensure t)

;; 重启 Emacs
(use-package restart-emacs
  :bind (("C-c r" . restart-emacs)))

;; 启动测速
(use-package benchmark-init
  :init
  (benchmark-init/activate)
  :hook (after-init . benchmark-init/deactivate))

;; 行移动 / 复制
(use-package move-dup
  :hook (after-init . global-move-dup-mode))

;; Ivy：选择增强
(use-package ivy
  :demand t
  :init
  (ivy-mode 1)
  :config
  (setq ivy-use-virtual-buffers t
        ivy-initial-inputs-alist nil
        ivy-count-format "(%d/%d) "
        enable-recursive-minibuffers t
        ivy-re-builders-alist '((t . ivy--regex-ignore-order))))

;; Counsel：常用命令增强
(use-package counsel
  :after ivy
  :init
  (counsel-mode 1)
  :bind (("M-x" . counsel-M-x)
         ("C-x C-f" . counsel-find-file)
         ("C-c f" . counsel-recentf)
         ("C-c g" . counsel-git)
         ("M-i" . counsel-imenu)))

;; Swiper：搜索增强
(use-package swiper
  :after ivy
  :bind (("C-s" . swiper)
         ("C-r" . swiper-isearch-backward))
  :config
  (setq swiper-action-recenter t
        swiper-include-line-number-in-search t))

;; Company：代码补全
(use-package company
  :hook (after-init . global-company-mode)
  :config
  (setq company-minimum-prefix-length 1
        company-idle-delay 0.2
        company-show-quick-access t
        company-tooltip-align-annotations t))

;; Flymake：语法检查，Emacs 内置
(use-package flymake
  :ensure nil
  :hook (prog-mode . flymake-mode)
  :bind (("M-n" . flymake-goto-next-error)
         ("M-p" . flymake-goto-prev-error)))

;; Crux：常用编辑增强
(use-package crux
  :bind (("C-a" . crux-move-beginning-of-line)
         ("C-c ^" . crux-top-join-line)
         ("C-x ," . crux-find-user-init-file)
         ("C-c k" . crux-smart-kill-line)))

;; Which-key：按键提示
(use-package which-key
  :init
  (which-key-mode 1)
  :config
  (setq which-key-idle-delay 0.5))

;; Ivy Posframe：Ivy 弹窗显示，仅 GUI 下启用
(use-package ivy-posframe
  :if (display-graphic-p)
  :after ivy
  :config
  (setq ivy-posframe-display-functions-alist
        '((t . ivy-posframe-display-at-frame-center)))
  (ivy-posframe-mode 1))

;; Ace-window：窗口选择
(use-package ace-window
  :bind (("M-o" . ace-window)))

;; Helpful：增强帮助文档
(use-package helpful
  :bind (("C-h ." . helpful-at-point)
         ("C-h k" . helpful-key)
         ("C-h v" . helpful-variable)
         ("C-h f" . helpful-callable)
         ("C-h F" . helpful-function)
         ("C-h x" . helpful-command)))

;; LSP：语言服务器
(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-keymap-prefix "C-c l")

  ;; 汇编文件识别
  (add-to-list 'auto-mode-alist '("\\.asm\\'" . asm-mode))
  (add-to-list 'auto-mode-alist '("\\.s\\'" . asm-mode))
  (add-to-list 'auto-mode-alist '("\\.S\\'" . asm-mode))
  (add-to-list 'auto-mode-alist '("\\.inc\\'" . asm-mode))

  ;; 如果你的 ASM LSP 需要手动注册，再取消这段注释
  ;; (add-to-list 'lsp-language-id-configuration
  ;;              '(asm-mode . "asm"))

  (defun my/lsp-before-save-actions ()
    "LSP 保存前操作。"
    (cond
     ((derived-mode-p 'go-mode 'js-mode 'python-mode 'zig-mode)
      (ignore-errors
        (lsp-organize-imports)))
     ((derived-mode-p 'asm-mode)
      nil)))

  :hook ((lsp-mode . lsp-enable-which-key-integration)
         (lsp-mode . (lambda ()
                       (add-hook 'before-save-hook
                                 #'my/lsp-before-save-actions
                                 nil
                                 t)))
         ((c-mode
           c++-mode
           go-mode
           asm-mode
           js-mode
           python-mode
           zig-mode)
          . lsp-deferred))

  :config
  (setq lsp-auto-guess-root t
        lsp-headerline-breadcrumb-enable nil
        lsp-log-io nil
        lsp-diagnostics-provider :flymake)

  ;; 如果 lsp-mode 无法自动找到你的 ASM LSP，在这里注册：
  ;; (lsp-register-client
  ;;  (make-lsp-client
  ;;   :new-connection (lsp-stdio-connection '("asm-lsp.exe"))
  ;;   :activation-fn (lsp-activate-on "asm")
  ;;   :major-modes '(asm-mode)
  ;;   :server-id 'asm-lsp))

  (define-key lsp-mode-map (kbd "C-c l") lsp-command-map))

;; LSP UI：增强界面
(use-package lsp-ui
  :after lsp-mode
  :hook ((lsp-mode . lsp-ui-mode)
         (lsp-ui-mode . lsp-modeline-code-actions-mode))
  :custom
  (lsp-ui-doc-include-signature t)
  (lsp-ui-doc-position 'at-point)
  (lsp-ui-sideline-ignore-duplicate t)
  :config
  (define-key lsp-ui-mode-map
              [remap xref-find-definitions]
              #'lsp-ui-peek-find-definitions)
  (define-key lsp-ui-mode-map
              [remap xref-find-references]
              #'lsp-ui-peek-find-references))

(provide 'init-package)