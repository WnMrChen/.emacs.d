;;; init-startup.el --- Startup optimization -*- lexical-binding: t; -*-

;; ================================
;; 编码设置
;; ================================

(set-language-environment "UTF-8")
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

;; Windows 下 selection/clipboard 编码有时不需要强制设置
;; 这里假设你在 init-const.el 中定义了 is-windows-p
;; (when (boundp 'is-windows-p)
;;   (unless is-windows-p
;;     (set-selection-coding-system 'utf-8)))

;; 如果你没有定义 is-windows-p，也可以直接这样写：
(unless (eq system-type 'windows-nt)
  (set-selection-coding-system 'utf-8))

;; ================================
;; GC 优化
;; ================================

(defvar default-gc-cons-threshold (* 96 1024 1024)
  "启动完成后的 GC 阈值。")

(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold default-gc-cons-threshold
                  gc-cons-percentage 0.1)
            (message "Emacs started in %.2f seconds with %d garbage collections."
                     (float-time
                      (time-subtract after-init-time before-init-time))
                     gcs-done)))

;; ================================
;; UI 基础设置
;; ================================

;; 关闭菜单栏
(when (fboundp 'menu-bar-mode)
  (menu-bar-mode -1))

;; 关闭工具栏
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))

;; 关闭滚动条
(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))

;; 关闭启动页
(setq inhibit-startup-screen t
      inhibit-startup-message t
      inhibit-startup-echo-area-message t)

(provide 'init-startup)