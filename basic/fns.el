(require 'thingatpt)
(require 'imenu)

;; Update the imenu index and then use ido to select a symbol to navigate to.
;; Symbols matching the text at point are put first in the
;; completion list.
(defun ido-imenu ()
  (interactive)
  (imenu--make-index-alist)
  (let ((name-and-pos '())
        (symbol-names '()))
    (flet ((addsymbols (symbol-list)
                       (when (listp symbol-list)
                         (dolist (symbol symbol-list)
                           (let ((name nil) (position nil))
                             (cond
                              ((and (listp symbol) (imenu--subalist-p symbol))
                               (addsymbols symbol))
                              
                              ((listp symbol)
                               (setq name (car symbol))
                               (setq position (cdr symbol)))
                              
                              ((stringp symbol)
                               (setq name symbol)
                               (setq position (get-text-property 1 'org-imenu-marker symbol))))
                             
                             (unless (or (null position) (null name))
                               (add-to-list 'symbol-names name)
                               (add-to-list 'name-and-pos (cons name position))))))))
      (addsymbols imenu--index-alist))
    ;; If there are matching symbols at point, put them at the beginning of `symbol-names'.
    (let ((symbol-at-point (thing-at-point 'symbol)))
      (when symbol-at-point
        (let* ((regexp (concat (regexp-quote symbol-at-point) "$"))
               (matching-symbols (delq nil (mapcar (lambda (symbol)
                                                     (if (string-match regexp symbol) symbol))
                                                   symbol-names))))
          (when matching-symbols
            (sort matching-symbols (lambda (a b) (> (length a) (length b))))
            (mapc (lambda (symbol) (setq symbol-names (cons symbol (delete symbol symbol-names))))
                  matching-symbols)))))
    (let* ((selected-symbol (ido-completing-read "Symbol? " symbol-names))
           (position (cdr (assoc selected-symbol name-and-pos))))
      (goto-char position))))

;; Window swapping
(labels
    ((swap (a b)
       (let* ((ba (window-buffer a))
          (bb (window-buffer b)) 
          (sa (window-start a))
          (sb (window-start b)))
         (set-window-buffer a bb)
         (set-window-buffer b ba)
         (set-window-start a sb)
         (set-window-start b sa))))
  (defun swap-windows ()
    "If you have 2 windows, it swaps them." (interactive)
    (cond ((not (= (count-windows) 2)) (message "You need exactly 2 windows to do this."))
      (t
       (let* ((w1 (first (window-list)))
          (w2 (second (window-list)))
          (b1 (window-buffer w1)))
         (swap w1 w2)))))
  (defun rotate-windows ()
    "Generalized version of swap-windows."
    (interactive)
    (cond ((< (count-windows) 2) (message "You need multiple windows in order to rotate them"))
      ((= (count-windows) 2) (swap-windows))
      (t (let* ((ws (window-list))
            (m (car ws))
            (r (cdr ws)))
           (mapc (lambda (w) (swap m w)) r))))))

(defun wc (&optional b e)
  "Count words in buffer"
  (interactive "r")
  (shell-command-on-region b e "wc -w"))