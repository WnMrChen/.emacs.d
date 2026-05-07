;; ================================
;; Emacs 字体配置
;; ================================

(defvar en-fonts-list
    '("JetBrainsMono Nerd Font"
    "JetBrainsMono NFM"
    "JetBrainsMono NF"
    "JetBrainsMonoNL Nerd Font"
    "Cascadia Code"
    "Consolas"
    "Courier New"))

(defvar cn-fonts-list
    '("Microsoft YaHei"
    "Microsoft YaHei UI"
    "SimHei"
    "SimSun"))

(defvar emoji-fonts-list
    '("Segoe UI Emoji"
    "Noto Color Emoji"
    "Symbola"))

(defun find-font (fonts)
    "返回 FONTS 中第一个可用字体。"
    (seq-find
    (lambda (font)
        (find-font (font-spec :family font)))
    fonts))

(defun setup-fonts ()
    "设置 Emacs 的中英文与 Emoji 字体。"
    (interactive)

    (let* ((en-font (find-font en-fonts-list))
            (cn-font (find-font cn-fonts-list))
            (emoji-font (find-font emoji-fonts-list))
            (size 120))

    ;; 默认英文字体
    (when en-font
        (set-face-attribute 'default nil
                            :family en-font
                            :height size)
        (set-face-attribute 'fixed-pitch nil
                            :family en-font
                            :height size)
        (add-to-list 'default-frame-alist
                    `(font . ,(format "%s-%d" en-font (/ size 10)))))

    ;; 阅读型非等宽字体
    (set-face-attribute 'variable-pitch nil
                        :family "Segoe UI"
                        :height size)

    ;; 中文字体
    (when cn-font
        (dolist (charset '(kana han cjk-misc bopomofo))
            (set-fontset-font t charset cn-font)))

    ;; Emoji 字体
    (when emoji-font
        (set-fontset-font t 'emoji emoji-font nil 'prepend)
        (set-fontset-font t 'symbol emoji-font nil 'prepend))

    ;; 字体比例修正
    (setq face-font-rescale-alist
            (append
            (when cn-font
                `((,cn-font . 1.15)))
            (when emoji-font
                `((,emoji-font . 1.0)))))

    (message "Font setup: English=%s, Chinese=%s, Emoji=%s"
            en-font cn-font emoji-font)))

(setup-fonts)

;; daemon / emacsclient 兼容
(add-hook 'after-make-frame-functions
            (lambda (frame)
                (when (display-graphic-p frame)
                (with-selected-frame frame
                    (setup-fonts)))))

(provide 'init-fonts)