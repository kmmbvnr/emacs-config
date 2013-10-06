;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; GNU Emacs configuration
;; (c) Mikhail Podgurskiy 2008-2012
;; kmmbvnr AT gmail.com
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defvar config-dir (file-name-directory load-file-name))

;; disable some stuff
(tool-bar-mode -1)
(unless window-system
    (menu-bar-mode -1))
(scroll-bar-mode -1)
(remove-hook 'find-file-hooks 'vc-find-file-hook)

;; Automatically compile init files
(defun byte-compile-init-file ()
  (when (and 
         (equal ".el" (substring buffer-file-name -3))
         (equal 0 (string-match config-dir (file-name-directory buffer-file-name))))
    (byte-compile-file buffer-file-name)))
(add-hook 'after-save-hook 'byte-compile-init-file)


;; Repositories
(require 'package)
(setq package-user-dir (concat config-dir "elpa"))
(add-to-list 'package-archives
             '("elpa" . "http://tromey.com/elpa/"))
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

(defvar my-packages '(bm
                      tabbar
                      smex
                      nav
                      color-theme
                      dired-single
                      fold-dwim
                      pony-mode
                      go-mode
                      flymake-jshint
                      flymake-csslint
                      flymake-python-pyflakes
                      web-mode))

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))


;; Package initialization
(require 'color-theme)
(require 'fold-dwim)
(require 'smex)
(smex-initialize)


(load (concat config-dir "session.el"))
(load (concat config-dir "elisp/inhibit-clash-detection.el"))
(load (concat config-dir "elisp/auto-highlight-symbol.el"))
(load (concat config-dir "elisp/multi-web-mode.el"))
(load (concat config-dir "elisp/sqlplus.el"))
(load (concat config-dir "elisp/protobuf-mode.el"))
(load (concat config-dir "elisp/plsql.el"))
(load (concat config-dir "elisp/go-mode-load.el"))
(load (concat config-dir "elisp/go-flymake.el"))
(load (concat config-dir "elisp/graphviz-dot-mode.el"))

;; Customization
(setq custom-file (concat config-dir "custom.el"))
(load-file custom-file)

;; Load subconfigs
(load (concat config-dir "look-and-feel.el"))
(load (concat config-dir "compile.el"))
(load (concat config-dir "python.el"))
(load (concat config-dir "javascript.el"))
(load (concat config-dir "keymap.el"))
(load (concat config-dir "email.el"))
(load (concat config-dir "web.el"))
(load (concat config-dir "xml.el"))
(load (concat config-dir "oracle.el"))

