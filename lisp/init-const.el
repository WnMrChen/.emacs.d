;;; init-const.el --- System constants -*- lexical-binding: t; -*-

(defconst is-mac-p
  (eq system-type 'darwin)
  "Non-nil if Emacs is running on macOS.")

(defconst is-linux-p
  (eq system-type 'gnu/linux)
  "Non-nil if Emacs is running on GNU/Linux.")

(defconst is-windows-p
  (memq system-type '(windows-nt ms-dos cygwin))
  "Non-nil if Emacs is running on Windows.")

(defconst is-wsl-p
  (and is-linux-p
       (or (getenv "WSL_DISTRO_NAME")
           (getenv "WSL_INTEROP")))
  "Non-nil if Emacs is running inside WSL.")

(defun graphic-p ()
  "Return non-nil if current frame is graphical."
  (display-graphic-p))

(provide 'init-const)