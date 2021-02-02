;;; init-local.el --- personal setting
;;; Commentary:
;;; Code:

;; auto install packages
;; https://emacs.stackexchange.com/questions/28932/how-to-automate-installation-of-packages-with-emacs-file
(dolist (package '(use-package))
  (unless (package-installed-p package)
    (package-install package)))

;; start server to use emacsclient -n
(server-start)

;; place all auto save files in a directory
;; https://emacs.stackexchange.com/questions/17210/how-to-place-all-auto-save-files-in-a-directory
(setq auto-save-file-name-transforms
      `((".*" "~/.emacs.d/auto-save-list/" t)))

;; email address
;; https://emacs.stackexchange.com/questions/26434/how-to-change-email-address-in-org-mode-publish-postamble
(setq user-mail-address "xyyuhans@hotmail.com")

;; spell check
(setq ispell-local-dictionary "english")

;; auto reload files
;; https://stackoverflow.com/questions/1480572/how-to-have-emacs-auto-refresh-all-buffers-when-files-have-changed-on-disk
(global-auto-revert-mode t)

;; make xdg-open works
;; https://emacs.stackexchange.com/questions/19344/why-does-xdg-open-not-work-in-eshell
(setq process-connection-type nil)

(provide 'init-local)
;;; init-local.el ends here
