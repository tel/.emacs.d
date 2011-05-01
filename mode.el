;; Python mode
;;
(add-to-path (dotpath "vendor/pymacs")
	     (dotpath "vendor/ropemacs")
	     (dotpath "vendor/python-mode"))

(require 'ipython)
(setq py-python-command-args '( "-colors" "Linux"))

(defadvice py-execute-buffer (around python-keep-focus activate)
  "Thie advice to make focus python source code after execute command `py-execute-buffer'."
  (let ((remember-window (selected-window))
        (remember-point (point)))
    ad-do-it
    (select-window remember-window)
    (goto-char remember-point)))

(setenv "PYMACS_PYTHON" *pythonpath*)
(eval-after-load "pymacs"
 '(progn 
    (add-to-list 'pymacs-load-path (dotpath "vendor/pymacs"))
    (add-to-list 'pymacs-load-path (dotpath "vendor/ropemacs"))
    (setenv "PYTHONPATH" (concat (getenv "PYTHONPATH") 
                                 ":" (dotpath "vendor/pymacs")))))
(load (dotpath "vendor/pymacs/pymacs.el"))
(require 'pymacs)
				 
(pymacs-load "ropemacs" "rope-")
(setq ropemacs-enable-autoimport t)

(setq yas/trigger-key (kbd "C-c <kp-multiply>"))
(yas/initialize)
(yas/load-directory "~/.emacs.d/snippets")

;; Auto-complete mode
;;
;; (add-to-path (dotpath "vendor/auto-complete"))
;; (require 'auto-complete-config)
;; (add-to-list 'ac-dictionary-directories (dotpath "vendor/auto-complete/dict"))
;; (setq ac-dwim t)
;; (setq ac-auto-start t)
;; (setq ac-auto-show-menu nil)
;; (setq ac-quick-help-delay 2)
;; (setq popup-use-optimized-column-computation nil)
;; (ac-config-default)

;; (global-auto-complete-mode t)

;; Cython mode
;;
(add-to-list 'auto-mode-alist '("\\.pyx\\'" . cython-mode))

(define-derived-mode cython-mode python-mode "Cython"
  (font-lock-add-keywords
   nil
   `((,(concat "\\<\\(NULL"
               "\\|c\\(def\\|har\\|typedef\\)"
               "\\|e\\(num\\|xtern\\)"
               "\\|float"
               "\\|in\\(clude\\|t\\)"
               "\\|object\\|public\\|struct\\|type\\|union\\|void"
               "\\)\\>")
      1 font-lock-keyword-face t))))

;; Haskell mode
;;
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)