;; Python-mode settings
(define-auto-insert "\.py" "python-template.py")

(add-hook 'python-mode-hook (lambda () 
			      (setq indent-tabs-mode nil)))


;; Insert breakpoint
(fset 'py-break
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([home home down return up tab 105 109 112 111 114 116 32 105 112 100 98 59 32 105 112 100 98 95 backspace 46 115 101 116 95 116 114 97 99 101 40 41 home] 0 "%d")) arg)))
(global-set-key "\C-c\M-p" 'py-break)


;; Django support
(defun get-file-in-upstream-dir (location filename)
  (let* ((dir (file-name-directory location))
         (path (concat dir filename)))
    (if (file-exists-p path)
        path
      (if (not (equal dir "/"))
          (get-file-in-upstream-dir (expand-file-name (concat dir "../")) filename)))))

(defadvice run-python (before possibly-setup-django-project-environment)
  (let* ((settings-py (get-file-in-upstream-dir buffer-file-name "settings.py"))
         (project-dir (file-name-directory settings-py)))
    (if settings-py
        (progn
          (setenv "DJANGO_SETTINGS_MODULE" "settings")
          (setenv "PYTHONPATH" project-dir)))))


(require 'flymake-python-pyflakes)
(add-hook 'python-mode-hook 'flymake-python-pyflakes-load)
(setq flymake-python-pyflakes-executable "flake8")


(defun flymake-create-temp-in-system-tempdir (filename prefix)
  (make-temp-file (or prefix "flymake")))

;; Flymake for python
;; (when (load "flymake" t) 
;;  (defun flymake-pyflakes-init ()
;;    (let* ((temp-file (flymake-init-create-temp-buffer-copy
;;                       'flymake-create-temp-in-system-tempdir))
;;           (local-file (file-relative-name
;;                        temp-file
;;                        (file-name-directory buffer-file-name))))
;;      (list "pyflakes" (list local-file))))

;; (add-to-list 'flymake-allowed-file-name-masks 
;;             '("\\.py\\'" flymake-python-pyflakes-load))

;; Additional functionality that makes flymake error messages appear 
;; in the minibuffer when point is on a line containing a flymake 
;; error. This saves having to mouse over the error, which is a 
;; keyboard user's annoyance 

;;flymake-ler(file line type text &optional full-file) 
(defun show-fly-err-at-point () 
  "If the cursor is sitting on a flymake error, display the 
   message in the minibuffer" 
  (interactive) 
  (let ((line-no (line-number-at-pos))) 
    (dolist (elem flymake-err-info) 
      (if (eq (car elem) line-no) 
	  (let ((err (car (second elem)))) 
	    (message "%s" (fly-pyflake-determine-message err)))))))

(defun fly-pyflake-determine-message (err) 
  "pyflake is flakey if it has compile problems, this adjusts the 
   message to display, so there is one ;)" 
  (cond ((not (or (eq major-mode 'Python) (eq major-mode 'python-mode) t))) 
	((null (flymake-ler-file err)) 
	 ;; normal message do your thing 
	 (flymake-ler-text err)) 
	(t ;; could not compile err 
	 (format "compile error, problem on line %s" (flymake-ler-line err)))))

(defadvice flymake-goto-next-error (after display-message activate compile) 
  "Display the error in the mini-buffer rather than having to mouse over it" 
  (show-fly-err-at-point))

(defadvice flymake-goto-prev-error (after display-message activate compile) 
  "Display the error in the mini-buffer rather than having to mouse over it" 
  (show-fly-err-at-point))

(defadvice flymake-mode (before post-command-stuff activate compile) 
  "Add functionality to the post command hook so that if the 
   cursor is sitting on a flymake error the error information is 
   displayed in the minibuffer (rather than having to mouse over 
   it)" 
  (set (make-local-variable 'post-command-hook) 
       (cons 'show-fly-err-at-point post-command-hook)))

;; (add-hook 'python-mode-hook 'flymake-find-file-hook)

(defun py-insert-super-call ()
  "Insert super method call at point"
  (interactive)
  (point-to-register 0)

  ;; class name
  (search-backward "class ")
  (forward-char 6)
  (set-mark-command nil)
  (search-forward "(")
  (backward-char 1)
  (kill-ring-save (mark) (point))
  (jump-to-register 0)

  ;; insert class name
  (insert "super(")
  (yank)
  (insert ", self).")

  ;; func name
  (point-to-register 0)
  (search-backward "def ")
  (forward-char 4)
  (set-mark-command nil)
  (search-forward "(")
  (backward-char 1)
  (kill-ring-save (mark) (point))
  (jump-to-register 0)

  ;; insert func name
  (yank)
  (insert "(")

  ;; args
  (point-to-register 0)
  (kill-ring-save (point) (point))
  (search-backward "def ")
  (save-excursion ;; TODO fix if no params
    (search-forward "self, ")
    (set-mark-command nil)
    (search-forward ")")
    (backward-char 1)
    (kill-ring-save (mark) (point)))
  (jump-to-register 0)

  ;; insert args
  (yank)
  (insert ")")
)

(global-set-key "\C-c\M-s" 'py-insert-super-call)
