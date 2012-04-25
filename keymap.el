;; Keyboard shortcuts
(global-set-key "\C-x\C-b" 'ibuffer)
(global-set-key "\C-c\M-g" 'magit-status)


;; Customized keybinding
(windmove-default-keybindings)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; This is your old M-x.
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

(global-set-key "\C-x\C-b" 'ibuffer)
(global-set-key "\C-c\M-c" 'clone-indirect-buffer)
(global-set-key "\C-c\M-t" 'toggle-truncate-lines)

(global-set-key [(control tab)] 'fold-dwim-toggle)

(global-set-key (kbd "<s-right>") `tabbar-forward-tab)
(global-set-key (kbd "<s-left>") `tabbar-backward-tab)
(global-set-key (kbd "<s-up>") `tabbar-forward-group)
(global-set-key (kbd "<s-down>") `tabbar-backward-group)
(global-set-key (kbd "<kp-enter>") `tabbar-press-home)

(global-set-key [C-f2]  'bm-toggle)
(global-set-key [(f2)]   'bm-next)
(global-set-key [(shift f2)] 'bm-previous)
(global-set-key [(control shift f2)] 'bm-show)
(global-set-key [(f5)] 'compile)
(global-set-key [(f3)] 'flymake-goto-next-error)
(global-set-key (kbd "C-c d") 'nav-right)
