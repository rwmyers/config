;;; Org-mode settings
(add-to-list 'load-path "~/.emacs.d/org/lisp")
(add-to-list 'load-path "~/.emacs.d/org/contrib/lisp")
(require 'org)
(setq org-todo-keywords
      '((sequence "TODO" "IMPEDED" "|" "DONE")))
;; MobileOrg
(setq org-directory "~/notes")
(setq org-mobile-directory "I:/Dropbox/MobileOrg/")
(setq org-mobile-inbox-for-pull "~/notes/index.org")
(setq org-mobile-files (list "~/notes/mstr.org" "~/notes/emacs.org" "~/notes/codingstandards.org" "~/notes/thoughts.org"))

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
;(load "~/.emacs.d/color-theme/themes/color-theme-molokai.el")
;(color-theme-molokai)
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

;; Disable splash screen
(setq inhibit-splash-screen t)
;; Goto-line short-cut key
(global-set-key "\C-l" 'goto-line)
;; Set kill line / delete like to Shift-delete
(global-set-key [S-delete] 'kill-line)
;; Switch to next/prev buffer w/ CTRL(+SHIFT)+TAB
(global-set-key (kbd "<C-tab>") 'bury-buffer)
(global-set-key (kbd "<C-S-tab>") 'unbury-buffer)
;; Disable kill confirmation
(remove-hook 'kill-buffer-query-functions 'server-kill-buffer-query-function)

;; Change tab into four spaces
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(tab-always-indent (quote complete))
 '(w32shell-cygwin-bin "C:\\cygwin\\bin"))

(require 'ansi-color)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
;(add-hook 'shell-mode-hook 'color-theme-solarized-dark)

;; shell settings
(add-hook 'shell-mode-hook
    '(lambda ()
        (local-set-key [home] ; move to beginning of line, after prompt
            'comint-bol)
        (local-set-key [up] ; cycle backward through command history
            '(lambda () (interactive)
                (if (comint-after-pmark-p)
                    (comint-previous-input 1)
                  (previous-line 1))))
        (local-set-key [down] ; cycle forward through command history
            '(lambda () (interactive)
                (if (comint-after-pmark-p)
                    (comint-next-input 1)
                  (forward-line 1))))
        ))

;; android
(load "~/.emacs.d/android.el")

;; always show line numbers
(global-linum-mode 1)

;; whitespace mode
(global-whitespace-mode 1)

;; Change font to Envy Code R
(set-default-font "Envy Code R-10")