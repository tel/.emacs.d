;; .emacs

;; Site configuration
(defvar *homepath* "/home/hltcoe/jabrahamson/")
(defun homepath (path) (concat *homepath* path))
(defvar *dotpath* (homepath ".emacs.d/"))
(defun dotpath (path) (concat *dotpath* path))

;; Local OS initialization
(mapcar (lambda (path) 
	  (add-to-list 'exec-path path))
	(list (homepath "local/")
	      "/usr/bin/"))

;; Continue the load
(load (dotpath "main.el"))
