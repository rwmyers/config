;;; Org-mode settings
(add-to-list 'load-path "~/.emacs.d/org/lisp")
(add-to-list 'load-path "~/.emacs.d/org/contrib/lisp")
(require 'org)
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(setq org-todo-keywords
      '((sequence "TODO" "IMPEDED" "|" "DONE")))
;; MobileOrg
(setq org-directory "~/notes")
(setq org-mobile-directory "I:/Dropbox/MobileOrg/")
(setq org-mobile-inbox-for-pull "~/notes/index.org")
(setq org-mobile-files (list "~/notes/mstr.org" "~/notes/emacs.org" "~/notes/codingstandards.org" "~/notes/thoughts.org"))

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
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(org-agenda-files (quote ("~/notes/emacs.org"))))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )
