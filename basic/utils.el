;; utils.el

;; Basic emacslisp utilities for running the .emacs initialization file

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
