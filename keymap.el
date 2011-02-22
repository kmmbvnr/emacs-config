;; Keyboard shortcuts
(global-set-key "\C-x\C-b" 'ibuffer)
(global-set-key "\C-c\M-g" 'magit-status)


;; Customized keybinding
(windmove-default-keybindings)

(global-set-key "\C-x\C-b" 'ibuffer)
(global-set-key "\C-c\M-c" 'clone-indirect-buffer)
(global-set-key "\C-c\M-t" 'toggle-truncate-lines)

(global-set-key [(control tab)] 'fold-dwim-toggle)

(global-set-key (kbd "<s-right>") `tabbar-forward-tab)
(global-set-key (kbd "<s-left>") `tabbar-backward-tab)
(global-set-key (kbd "<s-up>") `tabbar-forward-group)
(global-set-key (kbd "<s-down>") `tabbar-backward-group)

(global-set-key [C-f2]  'bm-toggle)
(global-set-key [(f2)]   'bm-next)
(global-set-key [(shift f2)] 'bm-previous)
(global-set-key [(control shift f2)] 'bm-show)

;; Ergo movement
(global-set-key "\M-j" 'backward-char)
(global-set-key "\M-l" 'forward-char)
(global-set-key "\M-i" 'previous-line)
(global-set-key "\M-k" 'next-line)
