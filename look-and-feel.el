;; Localisation
(set-language-environment "Russian")

;; Constants for quick environment tests
(defconst win32p
  (eq system-type 'windows-nt)
  "Are we running on a Windows system?")
(defconst linuxp
  (or (eq system-type 'gnu/linux)
      (eq system-type 'linux))
  "Are we running on a GNU/Linux system?")
(defconst macosp
  (eq system-type 'darwin),
  "Are we running in a MacOs?")


(when win32p
  (setq w32-pass-lwindow-to-system nil
        w32-pass-rwindow-to-system nil
        w32-pass-apps-to-system nil
        w32-lwindow-modifier 'super
        w32-rwindow-modifier 'super
        w32-apps-modifier 'hyper)
  (custom-set-faces
   '(default ((t (:inherit nil :stipple nil :background "beige"
                           :foreground "black" :inverse-video nil
                           :box nil :strike-through nil :overline nil
                           :underline nil :slant normal :weight normal
                           :height 101 :width normal :foundry "unknown"
                           :family "Lucida Console")))))
  (prefer-coding-system 'cp1251-dos))
(when linuxp
  (prefer-coding-system 'utf-8)
  (custom-set-faces
   '(default ((t (:inherit nil :stipple nil :background "beige" 
                           :foreground "black" :inverse-video nil 
                           :box nil :strike-through nil :overline nil 
                           :underline nil :slant normal :weight normal 
                           :height 101 :width normal :foundry "unknown" 
                           :family "Liberation Mono"))))))
(when macosp
  (prefer-coding-system 'utf-8)
  (custom-set-faces
   '(default ((t (:inherit nil :stipple nil :background "beige" 
                           :foreground "black" :inverse-video nil 
                           :box nil :strike-through nil :overline nil 
                           :underline nil :slant normal :weight normal 
                           :height 121 :width normal :foundry "unknown" 
                           :family "Menlo"))))))

;; Standard emacs functions
(fset 'yes-or-no-p 'y-or-n-p)
(put 'set-goal-column 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)


;; Clipboard fix
(when (and linuxp window-system)
  (setq x-select-enable-clipboard t)
  (setq interprogram-paste-function 'x-cut-buffer-or-selection-value))


;; Change cursor color depends on input method
(add-hook 'post-command-hook
          '(lambda()
             (set-cursor-color (if current-input-method "Orange" "Red"))))


;; IBuffer
(setq ibuffer-saved-filter-groups (quote (("default" 
					   ("Programming"
					    (or
					     (mode . c-mode)
					     (mode . perl-mode)
					     (mode . python-mode)
					     (mode . django-mode)
					     (mode . java-mode)
					     (mode . emacs-lisp-mode)
					     (mode . go-mode)
					     ;; etc
					     ))
					   ("Web"
					    (or
					     (mode . html-mode)
					     (mode . css-mode)
					     (mode . js-mode)
					     ))))))
(add-hook 'ibuffer-mode-hook
  (lambda ()
    (setq cursor-type nil)
    (hl-line-mode 1)
    (ibuffer-switch-to-saved-filter-groups "default")))


;; Color theme
(if window-system (color-theme-greiner) ;(color-theme-snow)
  (color-theme-arjen))


;; Hideshow
(add-hook 'c-mode-common-hook 'hs-minor-mode)
(add-hook 'sh-mode-hook 'hs-minor-mode)
(add-hook 'java-mode-hook 'hs-minor-mode)
(add-hook 'perl-mode-hook 'hs-minor-mode)
(add-hook 'emacs-lisp-mode-hook 'hs-minor-mode)
(add-hook 'lisp-mode-hook 'hs-minor-mode)
(add-hook 'python-mode-hook 'hs-minor-mode)

(defadvice goto-line (after expand-after-goto-linex
                            activate compile)
  (require 'hideshow)
  (save-excursion
    (hs-show-block)))
(define-fringe-bitmap 'hs-marker [0 24 24 126 126 24 24 0])
(defcustom hs-fringe-face 'hs-fringe-face
  "*Specify face used to highlight the fringe on hidden regions."
  :type 'face
  :group 'hideshow)
(defface hs-fringe-face
  '((t (:foreground "#888" :box (:line-width 2 :color "grey75" :style released-button))))
  "Face used to highlight the fringe on folded regions"
  :group 'hideshow)
(defcustom hs-face 'hs-face
  "*Specify the face to to use for the hidden region indicator"
  :type 'face
  :group 'hideshow)
(defface hs-face
  '((t (:background "#ff8" :box t)))
  "Face to hightlight the ... area of hidden regions"
  :group 'hideshow)

(defun display-code-line-counts (ov)
  (when (eq 'code (overlay-get ov 'hs))
    (let* ((marker-string "*fringe-dummy*")
           (marker-length (length marker-string))
           (display-string (format "(%d)..." (count-lines (overlay-start ov) (overlay-end ov))))
           )
      (overlay-put ov 'help-echo "Hiddent text. C-c,= to show")
      (put-text-property 0 marker-length 'display (list 'left-fringe 'hs-marker 'hs-fringe-face) marker-string)
      (overlay-put ov 'before-string marker-string)
      (put-text-property 0 (length display-string) 'face 'hs-face display-string)
      (overlay-put ov 'display display-string)
      )))

(setq hs-set-up-overlay 'display-code-line-counts)


;; Tabbar
(setq tabbar-buffer-groups-function
      (lambda () 
        (list (cond
               ((find (aref (buffer-name (current-buffer)) 0) " *") "*")
	       ((or (eq major-mode 'html-mode) 
		    (eq major-mode 'css-mode)
		    (eq major-mode 'js-mode))
		"Web")
	       ((or (eq major-mode 'python-mode)
		    (eq major-mode 'django-mode))
	        "Python")
               (t (if (and (stringp mode-name)
                           ;; Take care of preserving the match-data
                           ;; because this function is called when
                           ;; updating the header line.
                           (save-match-data (string-match "[^ ]" mode-name)))
                      mode-name
                    (symbol-name major-mode)))))))

;; add a buffer modification state indicator in the tab label,
 ;; and place a space around the label to make it looks less crowd
(defadvice tabbar-buffer-tab-label (after fixup_tab_label_space_and_flag activate)
  (setq ad-return-value
	(if (and (buffer-modified-p (tabbar-tab-value tab))
		 (buffer-file-name (tabbar-tab-value tab)))
	    (concat " + " (concat ad-return-value " "))
	  (concat " " (concat ad-return-value " ")))))
;; called each time the modification state of the buffer changed
(defun ztl-modification-state-change ()
  (tabbar-set-template tabbar-current-tabset nil)
  (tabbar-display-update))
;; first-change-hook is called BEFORE the change is made
(defun ztl-on-buffer-modification ()
  (set-buffer-modified-p t)
  (ztl-modification-state-change))
(add-hook 'after-save-hook 'ztl-modification-state-change)
;; this doesn't work for revert, I don't know
;;(add-hook 'after-revert-hook 'ztl-modification-state-change)
(add-hook 'first-change-hook 'ztl-on-buffer-modification)


;; Do not load vc backends automaticall
(eval-after-load "vc" '(remove-hook 'find-file-hooks 'vc-find-file-hook))

(require 'dired-single)

;; In dired, M-> and M-< never take me where I want to go.
(defun dired-back-to-top ()
  (interactive)
  (beginning-of-buffer)
  (dired-next-line 2))

(defun dired-jump-to-bottom ()
  (interactive)
  (end-of-buffer)
  (dired-next-line -1))

(defun my-dired-init ()
  "Bunch of stuff to run for dired, either immediately or when it's
        loaded."
  ;; <add other stuff here>
  (define-key dired-mode-map
    (vector 'remap 'beginning-of-buffer) 'dired-back-to-top)
  (define-key dired-mode-map
    (vector 'remap 'end-of-buffer) 'dired-jump-to-bottom)
  (define-key dired-mode-map [return] 'dired-single-buffer)
  (define-key dired-mode-map [mouse-1] 'dired-single-buffer-mouse)
  (define-key dired-mode-map "^"
    (function
     (lambda nil (interactive) (dired-single-buffer "..")))))

;; if dired's already loaded, then the keymap will be bound
(if (boundp 'dired-mode-map)
    ;; we're good to go; just add our bindings
    (my-dired-init)
  ;; it's not loaded yet, so add our bindings to the load-hook
  (add-hook 'dired-load-hook 'my-dired-init))

(global-auto-highlight-symbol-mode t)

(defun nav-right ()
  "Run nav-mode in a narrow window on the left side."
  (interactive)
  (require 'nav)
  (if (nav-is-open)
      (nav-quit)
    (delete-other-windows)
    (split-window-horizontally)
    ;;(other-window 1)
    (ignore-errors (kill-buffer nav-buffer-name))
    (pop-to-buffer nav-buffer-name nil)
    (set-window-dedicated-p (selected-window) t)
    (nav-mode)
    (linum-mode 0)
    (when nav-resize-frame-p
      (nav-resize-frame))))
