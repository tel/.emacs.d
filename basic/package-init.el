;; Package initialization
;;

;; Includes default install code.

(defun starter-kit-elpa-install (package-list)
  "Install all starter-kit packages that aren't installed."
  (interactive)
  (dolist (package package-list)
    (unless (or (member package package-activated-list)
                (functionp package))
      (message "Installing %s" (symbol-name package))
      (package-install package))))

(defun esk-online? ()
  "See if we're online."
  (if (and (functionp 'network-interface-list)
           (network-interface-list))
      (some (lambda (iface) (unless (equal "lo" (car iface))
			      (member 'up (first (last (network-interface-info
							(car iface)))))))
            (network-interface-list))
    t))

(defun do-packages (package-list)
  (progn 
    (when (esk-online?)
      (unless package-archive-contents (package-refresh-contents))
      (starter-kit-elpa-install package-list))
    (autoload 'paredit-mode "paredit" "" t)
    (autoload 'yaml-mode "yaml-mode" "" t)))

(defun install-package-from-url (sym url)
  (unless (or (member sym package-activated-list)
	      (functionp sym))
    (let ((path (concat "/tmp/" (car (last (split-string url "/"))))))
      (url-copy-file url path)
      ;; gunzip if necessary and update the path to the new file
      (if (string= (car (last (split-string blahstr "\\."))) "gz")
	  (progn
	    (shell-command (concat "gunzip " path))
	    (setq path (substring path 0 -3))))
      ;; Do the actual install
      (package-install-file path)
      ;; Kill the dl'd file
      (shell-command (concat "rm -f " path)))))