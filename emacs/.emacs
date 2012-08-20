; Org-mode settings
(add-to-list 'load-path "~/.emacs.d/org/lisp")
(add-to-list 'load-path "~/.emacs.d/org/contrib/lisp")
(require 'org)
(setq org-todo-keywords
      '((sequence "TODO" "IMPEDED" "|" "DONE")))

;; Extension registration
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(add-to-list 'auto-mode-alist '("\\.build\\'" . xml-mode))
(add-to-list 'auto-mode-alist '("\\.config\\'" . xml-mode))

; Color-theme settings
(add-to-list 'load-path "~/.emacs.d/color-theme/")
(add-to-list 'load-path "~/.emacs.d/color-theme/themes/solarized/")
(require 'color-theme)
(require 'color-theme-solarized)
(color-theme-solarized-light)

; helping functions
(defun cygwin-shell ()
  "Run cygwin bash in shell mode."
  (interactive)
  (let ((explicit-shell-file-name "C:/cygwin/bin/bash"))
    (call-interactively 'shell)))

;; functions 
(message "LOADING FUNCTIONS..")
(load "~/.emacs.d/functions/configs.el")

;; git
(add-to-list 'load-path "~/.emacs.d/git/")
(require 'git)

(load "~/.emacs.d/git/git-commit.el")

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
