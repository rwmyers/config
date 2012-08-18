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
;(eval-after-load "color-theme"
;  '(progn
;     (color-theme-initialize)
;     (color-theme-solarized-light)))

;(if window-system
;    (color-theme-subtle-hacker)
;    (color-theme-hober))

; Visible whitespace mode (visws.el)
(add-to-list 'load-path "~/.emacs.d/")
(load "~/.emacs.d/visws.el")
(visible-whitespace-mode)

; General settings
; Allows for deletion of selected text and sets transient-mark-mode
(delete-selection-mode t)
(server-start)
(setq inhibit-splash-screen t)
;; Goto-line short-cut key
(global-set-key "\C-l" 'goto-line)
;; Set kill line / delete like to Shift-delete
(global-set-key [S-delete] 'kill-line)
