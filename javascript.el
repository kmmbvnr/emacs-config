;; To use JSHint with emacs, you will need JSHint installed and available on
;; your path. You should be able to do

;; $ jshint

;; without problem. To do this, you can install node.js, npm and
;; jshint by doing the following:

;; $ apt-get install nodejs # or your distro / OS equivalent
;; $ curl http://npmjs.org/install.sh | sh
;; $ npm install -g jshint

;; You will probably want to configure the warnings that JSHint
;; produces. The full list is at http://www.jshint.com/options/ but
;; for reference I use:

;; { "browser": true, //browser constants, such as alert
;;   "curly": true, // require {} on one-line if
;;   "undef": true, // non-globals must be declared before use
;;   "newcap": true, // constructors must start with capital letter
;;   "jquery": true, // jQuery constants
;;   "nomen": false, // permit leading/trailing underscores, these do actually m
;;   "nonew": true, // don't permit object creation for side-effects only
;;   "strict": true // require "use strict";
;; }

(require 'flymake-jshint)
(add-hook 'js-mode-hook 'flymake-mode)
(delete '("\\.html?\\'" flymake-xml-init) flymake-allowed-file-name-masks)
