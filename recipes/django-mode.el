(:name django-mode
       :type git
       :url "https://github.com/myfreeweb/django-mode.git"
       :features django-mode
       :load  ("django-mode.el" "django-html-mode.el")
       :after (lambda() 
		(require 'django-mode)))
