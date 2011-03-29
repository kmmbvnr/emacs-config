;;; jslint.el --- Flymake for jslint

(require 'flymake)
(require 'js)

(defvar jslint-dir (concat  config-dir "jslint/"))

(defun flymake-jslint-init ()
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
		     'flymake-create-temp-inplace))
         (local-file (file-relative-name
		      temp-file
		      (file-name-directory buffer-file-name))))
    (list "rhino" (list 
		   (concat jslint-dir "jslint_runner.js")
		   (concat jslint-dir "JSLint/fulljslint.js") 
		   local-file))))

(setq flymake-allowed-file-name-masks
      (cons '(".+\\.js$"
	      flymake-jslint-init
	      flymake-simple-cleanup
	      flymake-get-real-file-name)
	    flymake-allowed-file-name-masks))

(require 'js2-mode)
(defun my-js2-mode-hook () 
  (set (make-local-variable 'indent-line-function) 'js-indent-line)
  (flymake-mode t))

(add-hook 'js2-mode-hook 'my-js2-mode-hook)

