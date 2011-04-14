;; tweaks.el

;; Small running tweaks that will annoy every other emacs user except me

;; Settings (various)
;;
(setq visible-bell t
      transient-mark-mode t
      auto-compression-mode t
      tab-width 2
      indent-tabs-mode nil)
(global-auto-revert-mode)

;; Make M-x easier to hit
;;
(global-set-key "\C-x\C-m" 'execute-extended-command)
(global-set-key "\C-xm" 'execute-extended-command)
(global-set-key "\C-c\C-m" 'execute-extended-command)

;; Make backwards-kill-word Easier
;;
(global-set-key "\C-w" 'backward-kill-word)
(global-set-key "\C-x\C-k" 'kill-region)
(global-set-key "\C-c\C-k" 'kill-region)

;; Clever text size changing
(define-key global-map (kbd "C-+") 'text-scale-increase)
(define-key global-map (kbd "C--") 'text-scale-decrease)

;; I have no idea  
(defmacro make-region-indent-completion-function (completion-command &optional indent-command)
  (let ((mark-active (if (boundp mark-active) 'mark-active 'emacs-region-active-p))
    (indent (or indent-command '(indent-for-tab-command))))
    `(lambda ()
       (interactive)
       (if ,mark-active
       (indent-region (mark) (point) nil)
     (if (save-excursion (skip-chars-backward " \t") (bolp))
         ,indent
       ,completion-command)))))
  
(define-key emacs-lisp-mode-map (kbd "<tab>")
  (make-region-indent-completion-function (lisp-complete-symbol)))

;; Ease usage of query-replace-regex
;;
(defalias 'qrr 'query-replace-regexp)
(defalias 'rr 'replace-regexp)

;; Remove toolbar clutter
;;
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

;; Turn on font-lock mode
;;
(when (fboundp 'global-font-lock-mode)
  (global-font-lock-mode t))

;; enable visual feedback on selections
(setq transient-mark-mode t)

;; default to better frame titles
(setq frame-title-format
      (concat  "%b - emacs@" (system-name)))

;; default to unified diffs
(setq diff-switches "-u")

;; Centralize autosaves
;;
(defvar autosave-dir
  (concat "/tmp/emacs_autosaves/" (user-login-name) "/"))
(make-directory autosave-dir t)
(setq auto-save-file-name-transforms 
      `(("\\(?:[^/]*/\\)*\\(.*\\)" ,(concat
				     autosave-dir "\\1") t)))

(defvar backup-dir (concat "/tmp/emacs_backups/" (user-login-name) "/"))
(setq backup-directory-alist (list (cons "." backup-dir)))