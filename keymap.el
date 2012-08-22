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

(require 'fold-dwim)
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


;; Recode shortcuts in russian-layout
(defun reverse-input-method (input-method)
  "Build the reverse mapping of single letters from INPUT-METHOD."
  (interactive
   (list (read-input-method-name "Use input method (default current): ")))
  (if (and input-method (symbolp input-method))
      (setq input-method (symbol-name input-method)))
  (let ((current current-input-method)
        (modifiers '(nil (control) (meta) (control meta))))
    (when input-method
      (activate-input-method input-method))
    (when (and current-input-method quail-keyboard-layout)
      (dolist (map (cdr (quail-map)))
        (let* ((to (car map))
               (from (quail-get-translation
                      (cadr map) (char-to-string to) 1)))
          (when (and (characterp from) (characterp to))
            (dolist (mod modifiers)
              (define-key local-function-key-map
                (vector (append mod (list from)))
                (vector (append mod (list to)))))))))
    (when input-method
      (activate-input-method current))))

(reverse-input-method 'russian-computer)
