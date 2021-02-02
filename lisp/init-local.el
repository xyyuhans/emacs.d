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

;; org mode
(setq org-default-notes-file "~/Nutstore Files/sync/orgmode/todo.org")
(setq org-agenda-files '("~/Nutstore Files/sync/orgmode" "~/Nutstore Files/sync/orgmode/hidden" "~/Syncthing/backup/org"))
(setq org-archive-location "~/Nutstore Files/sync/orgmode/archive::")
;; auto truncate
;; https://superuser.com/questions/299886/linewrap-in-org-mode-of-emacs/299897
(setq org-startup-truncated nil)
;; set tag interval to 0
;; https://emacs.stackexchange.com/questions/10524/too-much-whitespace-on-setting-org-mode-tags
(setq org-tags-column 0)
;; orgmode don't set repeat task to NEXT
(setq org-todo-repeat-to-state nil)
;; show superscript
(setq org-pretty-entities 1)
;; org agenda sort
(setq org-agenda-sorting-strategy
      '((agenda time-up priority-down habit-down user-defined-up effort-up category-keep)
        (todo category-up effort-up)
        (tags category-up effort-up)
        (search category-up)))

(provide 'init-local)
;;; init-local.el ends here
