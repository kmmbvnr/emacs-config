;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; GNU Emacs configuration
;; (c) Mikhail Podgurskiy 2008-2010
;; kmmbvnr AT gmail.com
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defvar config-dir (file-name-directory load-file-name))

;; as soon as possible
(tool-bar-mode -1)
;;(menu-bar-mode -1)
(scroll-bar-mode nil)

;; Automatically compile the init files
(defun byte-compile-init-file ()
  (when (equal 0 (string-match config-dir 
			       (file-name-directory buffer-file-name)))
    (byte-compile-file buffer-file-name)))
(add-hook 'after-save-hook 'byte-compile-init-file)

;; el-get installation
(defvar elisp-dir (concat  (file-name-directory load-file-name) "elisp/"))
(defvar el-get-dir elisp-dir)
(defvar el-get-recipe-path
  (list 
   (concat config-dir "recipes")
   (concat el-get-dir "el-get/recipes/")))

(let* ((package "el-get")
       (el-get-path (concat el-get-dir package "/el-get.el")))
  (if (not (load el-get-path t))
      (let* ((dummy (unless (file-directory-p el-get-dir)
		      (make-directory el-get-dir t)))
	     (bname "*el-get bootstrap*")
	     (git (or (executable-find "git") (error "Unable to find `git'")))
	     (url "git://github.com/dimitri/el-get.git")
	     (el-get-sources `((:name ,package :type "git" :url ,url :features el-get :compile "el-get.el")))
	     (default-directory el-get-dir)
	     (process-connection-type nil) ; pipe, no pty (--no-progress)
	     (status  (call-process git nil bname t "--no-pager" "clone" "-v" url package)))
	(set-window-buffer (selected-window) bname)
	(when (eq 0 status)
	  (load el-get-path)
	  (el-get-init "el-get")
	  (with-current-buffer bname
	    (goto-char (point-max))
	    (insert "\nCongrats, el-get is installed and ready to serve!"))))))

(setq el-get-sources '(color-theme bm hideshowvis fold-dwim tabbar magit))

(el-get 'sync)
(el-get 'wait)

(load (concat config-dir "session.el"))

;; customize
(setq custom-file (concat config-dir "custom.el"))
(load-file custom-file)

;; load subconfigs
(load (concat config-dir "look-and-feel.el"))
(load (concat config-dir "python.el"))
(load (concat config-dir "keymap.el"))

;; autoinsert
(require 'autoinsert)
(setq auto-insert-directory (concat config-dir "templates"))
(setq auto-insert-query nil)
