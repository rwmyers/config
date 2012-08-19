;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Functions for .emacs configuration manipulation.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(message "Loading configurations functions...")
(defun reload-config ()
  "Reload your .emacs file without restarting Emacs"
  (interactive)
  (load-file "~/.emacs"))

(defun open-config ()
  "Open your .emacs file"
  (interactive)
  (find-file "~/.emacs"))