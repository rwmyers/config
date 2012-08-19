; Org-mode settings
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(setq org-todo-keywords
      '((sequence "TODO" "IMPEDED" "|" "DONE")))

; Color-theme settings
(add-to-list 'load-path "~/.emacs.d/color-theme/")
(add-to-list 'load-path "~/.emacs.d/color-theme/themes/solarized/")
(require 'color-theme)
(require 'color-theme-solarized)
(color-theme-solarized-light)

; Visible whitespace mode (visws.el)
(add-to-list 'load-path "~/.emacs.d/")
(load "~/.emacs.d/visws.el")
;(visible-whitespace-mode)

; helping functions

;; reload configuration function
(defun reload-config ()
  "Reload your .emacs file without restarting Emacs"
  (interactive)
  (load-file "~/.emacs"))

;; find .emacs file
(defun open-config ()
  "Open your .emacs file"
  (interactive)
  (find-file "~/.emacs"))

(defun cygwin-shell ()
  "Run cygwin bash in shell mode."
  (interactive)
  (let ((explicit-shell-file-name "C:/cygwin/bin/bash"))
    (call-interactively 'shell)))

;; functions 
(add-to-list 'load-path "~/.emacs.d/functions/")

;; git
(add-to-list 'load-path "~/.emacs.d/git/")
(require 'git)

; General settings
; Allows for deletion of selected text and sets transient-mark-mode
(delete-selection-mode t)
;; Starting 
(load "server")
(unless (server-running-p) (server-start))

(setq inhibit-splash-screen t)
;; Goto-line short-cut key
(global-set-key "\C-l" 'goto-line)
;; Set kill line / delete like to Shift-delete
(global-set-key [S-delete] 'kill-line)
;; Switch to next/prev buffer w/ CTRL(+SHIFT)+TAB
(global-set-key (kbd "<C-tab>") 'bury-buffer)
(global-set-key (kbd "<C-S-tab>") 'unbury-buffer)
