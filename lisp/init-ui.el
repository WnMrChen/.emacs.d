;;; init-ui.el --- UI configuration -*- lexical-binding: t; -*-

;; Catppuccin 主题
(use-package catppuccin-theme
  :ensure t
  :init
  ;; 可选值：'latte 'frappe 'macchiato 'mocha
  ;; latte      = 亮色
  ;; frappe     = 柔和暗色
  ;; macchiato  = 中等暗色
  ;; mocha      = 最深暗色，默认推荐
  (setq catppuccin-flavor 'mocha)
  :config
  (load-theme 'catppuccin t))

;; 状态栏
(use-package smart-mode-line
  :ensure t
  :init
  (setq sml/no-confirm-load-theme t
        sml/theme 'respectful)
  :config
  (sml/setup))

;; 相对行号
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode t)

(provide 'init-ui)