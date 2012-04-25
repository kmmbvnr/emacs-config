;; Storage for computer specific files
(defconst local-saves-dir
  (expand-file-name
   (downcase (concat "~/.emacs.local/saves/" system-name "-"
		     (symbol-name system-type) "/"))))

;; ido saves
(setq ido-save-directory-list-file
      (concat local-saves-dir "ido.last"))


;; All backups in one dir
(setq backup-by-copying t
      backup-directory-alist (list (cons "." local-saves-dir))
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)


;; recentf
(setq recentf-save-file
      (concat local-saves-dir "recentf"))


;; auto-save
(setq auto-save-list-file-prefix
      (concat local-saves-dir "saves-"))

;; smex
(setq smex-save-file (concat local-saves-dir "smex-items"))
