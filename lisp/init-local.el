;;; init-local.el --- personal setting
;;; Commentary:
;;; Code:

;; auto install packages
;; https://emacs.stackexchange.com/questions/28932/how-to-automate-installation-of-packages-with-emacs-file
(dolist (package '(use-package))
  (unless (package-installed-p package)
    (package-install package)))

(provide 'init-local)
;;; init-local.el ends here
