; Org-mode settings
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(setq org-todo-keywords
      '((sequence "TODO" "IMPEDED" "|" "DONE")))

; Color-theme settings
(add-to-list 'load-path "~/.emacs.d/color-theme/")
(require 'color-theme)
(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
     (color-theme-monokai)))

; Visible whitespace mode (visws.el)
(add-to-list 'load-path "~/.emacs.d/")
(load "~/.emacs.d/visws.el")
(visible-whitespace-mode)

; General settings
; Allows for deletion of selected text and sets transient-mark-mode
(delete-selection-mode t)
(server-start)
(setq inhibit-splash-screen t)
