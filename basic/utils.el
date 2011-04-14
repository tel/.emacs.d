;; utils.el

;; Basic emacslisp utilities for running the .emacs initialization file

;; Path functions
;;
(defun add-to-path (thing &rest paths)
  (add-to-list 'load-path thing)
  (mapcar (lambda (path) (add-to-list 'load-path path))
	  paths))

;; Autoload Macros
;;
(defmacro autoload-then (args &rest block)
  (if (eq block nil)
	  `(autoload ,@args)
	`(progn
	   (autoload ,@args)
	   (eval-after-load ,(cadr args) ; the file name
		 (progn ,@block)))))

(defmacro autoload-helper (file fns)
  `(progn
     ,@(let ((var (gensym)))
         (mapcar (lambda (,var)
                   `(autoload ,(car ,var) ,file ,@(cdr ,var)))
                 fns))))

(defmacro autoload-multiple (file others &rest block)
  (if (eq block nil)
      `(autoload-helper ,file ,others)
    `(progn
       (autoload-helper ,file ,others)
       (eval-after-load ,file
         (progn ,@block)))))
