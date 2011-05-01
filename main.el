;; .emacs

(setq inhibit-splash-screen t)

;; Bootstrap
(require 'cl)
(load (dotpath "basic/backquotes.el"))
(load (dotpath "basic/utils.el"))
(load (dotpath "basic/tweaks.el"))

;; ELPA Initialization
;;
(when (load (expand-file-name "~/.emacs.d/elpa/package.el"))
  (package-initialize))
(load (dotpath "basic/package-init.el"))

(dolist (source '(("josh" . "http://josh.github.com/elpa/")
                  ("technomancy" . "http://repo.technomancy.us/emacs/")
                  ("elpa" . "http://tromey.com/elpa/")))
  (add-to-list 'package-archives source t))

; Install all the defaults
(package-initialize)
(do-packages (list 'idle-highlight
		   'css-mode
		   'yaml-mode
		   'find-file-in-project
		   'magit
		   'gist
		   'paredit
		   'full-ack
		   'haskell-mode
		   'yasnippet-bundle
		   'zenburn))
(install-package-from-url 'auctex 
			  "http://elpa.gnu.org/packages/auctex-11.86.tar")

;; Load custom functions
;;
(load (dotpath "basic/fns.el"))

;; Color Theme
;;
(add-to-path (dotpath "color-theme"))
(require 'color-theme)
(color-theme-zenburn)

;; Custom bindings
(global-set-key (kbd "C-x [")           'vi-mode)
(global-set-key (kbd "C-x g")		'magit-status)
(global-set-key (kbd "C-c C-g")		'gist-region-or-buffer)
(global-set-key (kbd "C-x 4 r")		'rotate-windows)
(global-set-key (kbd "C-x C-i")		'ido-imenu)
(global-set-key (kbd "C-x M-f")		'ido-find-file-other-window)
(global-set-key (kbd "C-x C-M-f")	'find-file-in-project)
(global-set-key (kbd "C-x f")		'recentf-ido-find-file)
(global-set-key (kbd "C-c y")		'bury-buffer)
(global-set-key (kbd "C-x C-b")		'ibuffer)

(define-key global-map "\C-cl"		'org-store-link)
(define-key global-map "\C-ca"		'org-agenda)

;; Matlab
(add-to-list 'load-path (dotpath "matlab/"))
(load-library "matlab-load")

;; Ido Mode
(require 'ido)
(ido-mode)

;; Extra modes
(load (dotpath "mode.el"))

;; Start up a shell
(shell)
