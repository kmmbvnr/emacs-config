(:name django-mode
       :type git
       :url "https://github.com/nonsequitur/smex.git"
       :features smex
       :load  ("smex.el")
       :after (lambda() 
		(require 'smex)
		(smex-initialize)))

