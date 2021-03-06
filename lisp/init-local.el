;;; init-local.el --- personal setting
;;; Commentary:
;;; Code:

;; package proxy
(setq url-proxy-services
      '(("no_proxy" . "^\\(localhost\\|10.*\\)")
        ("http" . "127.0.0.1:8119")
        ("https" . "127.0.0.1:8119")))

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
(setq auto-save-visited-interval 60)

;; auto save
;; https://www.emacswiki.org/emacs/AutoSave#h5o-4
(auto-save-visited-mode)

;; make xdg-open works
;; https://emacs.stackexchange.com/questions/19344/why-does-xdg-open-not-work-in-eshell
(setq process-connection-type nil)

;; truncate
(add-hook 'eww-after-render-hook '(lambda () (setq truncate-lines nil)))

;; org mode
(setq org-default-notes-file "~/Nutstore Files/sync/orgmode/inbox.org")
(setq org-agenda-files '("~/Nutstore Files/sync/orgmode" "~/Nutstore Files/sync/orgmode/hidden" "~/Syncthing/backup/org"))
(setq org-archive-location "~/Syncthing/backup/org/archive::")
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
      '((agenda time-up scheduled-down deadline-up priority-down todo-state-up habit-down user-defined-up effort-up category-keep)
        (todo category-up effort-up)
        (tags category-up effort-up)
        (search category-up)))
;; org agenda effort view
;; https://emacs.stackexchange.com/questions/21380/show-sum-of-efforts-for-a-day-in-org-agenda-day-title
;; (setq org-columns-default-format "%60ITEM(Task) %6Effort(Estim){:}")
;; C-j will indent instead of enter
(electric-indent-mode t)
;; my-org-delete-indentation
;; not done yet, if the previous line is empty
(defun my-org-delete-indentation ()
  "Customized org-delete-indentation for Chinese."
  (interactive)
  (org-delete-indentation)
  (org-delete-char 1))
(global-set-key (kbd "C-M-^") 'my-org-delete-indentation)

;; https://github.com/org-roam/org-roam
(use-package org-roam
  :ensure t
  :hook
  (after-init . org-roam-mode)
  :custom
  (org-roam-directory "~/Syncthing/backup/orgroam")
  ;; disable property auto insert
  ;; https://github.com/org-roam/org-roam/pull/1030
  ;; https://github.com/org-roam/org-roam/issues/1029
  (org-roam-enable-headline-linking nil)
  ;; auto truncate
  (org-startup-truncated nil)
  :bind (:map org-roam-mode-map
              (("C-c n l" . org-roam)
               ("C-c n f" . org-roam-find-file)
               ("C-c n g" . org-roam-graph-show))
              :map org-mode-map
              (("C-c n i" . org-roam-insert))
              (("C-c n I" . org-roam-insert-immediate))))

(use-package org-roam-server
  :ensure t
  :config
  (setq org-roam-server-host "127.0.0.1"
        org-roam-server-port 8080
        org-roam-server-export-inline-images t
        org-roam-server-authenticate nil
        org-roam-server-network-poll t
        org-roam-server-network-arrows nil
        org-roam-server-network-label-truncate t
        org-roam-server-network-label-truncate-length 60
        org-roam-server-network-label-wrap-length 20))

;; https://github.com/tumashu/cnfonts
(use-package cnfonts
  :ensure t
  :config
  (cnfonts-enable))

;; https://github.com/rranelli/auto-package-update.el
(use-package auto-package-update
  :ensure t
  :config
  (setq auto-package-update-delete-old-versions t
        auto-package-update-interval 7)
  (auto-package-update-maybe))

(use-package anki-editor
  :ensure t
  ;; http://blog.lujun9972.win/emacs-document/blog/2020/01/14/%E4%BD%BF%E7%94%A8emacs%EF%BC%8Corg-mode%EF%BC%8Canki-editor%E7%AD%89%E6%8F%92%E4%BB%B6%E5%90%AF%E5%8A%A8anki/index.html
  :bind (:map org-mode-map
              ("<f9>" . anki-editor-cloze-region-dont-incr))
  :config
  (defun anki-editor-cloze-region-dont-incr (&optional arg)
    "Cloze region without hint using the previous card number."
    (interactive)
    (anki-editor-cloze-region arg "")))

(use-package org-wild-notifier
  :ensure t
  :custom
  (org-wild-notifier-alert-time '(0))
  (org-wild-notifier-keyword-whitelist nil)
  :config
  (org-wild-notifier-mode)
  (setq alert-default-style 'libnotify))

(use-package ox-reveal
  :ensure t
  :custom
  (org-reveal-root "file:////home/xyyuhans/Documents/reveal.js")
  ;; https://github.com/yjwen/org-reveal/issues/388#issuecomment-652182364
  ;; Wrap <img> tag in a <figure> tag
  (org-html-html5-fancy t)
  (org-html-doctype "html5"))

(use-package org-mind-map
  :init
  (require 'ox-org)
  :ensure t
  ;; Uncomment the below if 'ensure-system-packages` is installed
  ;;:ensure-system-package (gvgen . graphviz)
  :config
  ;; (setq org-mind-map-engine "neato")  ; Undirected Spring Graph
  ;; (setq org-mind-map-engine "twopi")  ; Radial Layout
  ;; (setq org-mind-map-engine "fdp")    ; Undirected Spring Force-Directed
  ;; (setq org-mind-map-engine "sfdp")   ; Multiscale version of fdp for the layout of large graphs
  ;; (setq org-mind-map-engine "twopi")  ; Radial layouts
  ;; (setq org-mind-map-engine "circo")  ; Circular Layout
  ;; Default. Directed Graph
  (setq org-mind-map-engine "dot"))

(use-package ox-hugo
  :ensure t
  :after ox
  :custom
  (org-hugo-section "post"))

(use-package ein
  :ensure t)

;; https://emacs.stackexchange.com/questions/56050/problem-with-use-package-and-matlab-mode-cannot-load
(use-package matlab
  :ensure matlab-mode)

(use-package org-noter
  :ensure t
  :custom
  (org-noter-doc-split-fraction '(0.65 . 0.5))
  ;; https://github.com/weirdNox/org-noter/issues/80
  ;; location saved in org file, open from org file works, open from pdf doesn't work
  (org-noter-auto-save-last-location 1))

(use-package pdf-tools
  :ensure t
  :custom
  (pdf-view-display-size 'fit-width)
  ;; https://www.gnu.org/software/emacs/manual/html_node/elisp/Auto-Major-Mode.html
  :config
  (pdf-loader-install)
  (add-to-list 'auto-mode-alist '("\\.pdf\\'" . pdf-view-mode)))

(use-package nov
  :ensure t
  :custom
  ;; copy text without truncate
  (nov-text-width t)
  :config
  ;; open epub in this mode
  ;; https://depp.brause.cc/nov.el/
  (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode)))

(use-package org-ref
  :ensure t
  :config
  (setq org-latex-pdf-process (list "latexmk -shell-escape -bibtex -f -pdf %f")))

(use-package org-journal
  :ensure t
  :config
  (setq org-journal-dir "~/Syncthing/backup/orgjournal/")
  (global-set-key (kbd "C-c j j") 'org-journal-new-entry)
  ;; disable visual-line and enable org-startup-truncated
  ;; https://stackoverflow.com/questions/29169210/how-to-disable-global-minor-mode-in-a-specified-major-mode
  (add-hook 'org-journal-mode-hook (lambda () (visual-line-mode -1)))
  (setq org-startup-truncated nil)
  ;; to make use of TODO auto migrate
  (setq org-journal-time-prefix "** TODO ")
  (setq org-journal-file-format "%Y%m%d.org"))

(use-package org-download
  :ensure t)

(use-package org-gtd
  :ensure t
  :after org
  :demand t ;; without this, the package won't be loaded, so org-agenda won't be configured
  :custom
  ;; where org-gtd will put its files. This value is also the default one.
  (org-gtd-directory "~/Nutstore Files/sync/orgmode/")
  ;; package: https://github.com/Malabarba/org-agenda-property
  ;; this is so you can see who an item was delegated to in the agenda
  (org-agenda-property-list '("DELEGATED_TO"))
  ;; I think this makes the agenda easier to read
  (org-agenda-property-position 'next-line)
  ;; package: https://www.nongnu.org/org-edna-el/
  ;; org-edna is used to make sure that when a project task gets DONE,
  ;; the next TODO is automatically changed to NEXT.
  (org-edna-use-inheritance t)
  :config
  (org-edna-load)
  ;; remove all tag setting
  ;; not scheduled for incubate, check it regularly
  (defun org-gtd--incubate ()
    "Process GTD inbox item by incubating it.
Allow the user apply user-defined tags from
`org-tag-persistent-alist', `org-tag-alist' or file-local tags in
the inbox.  Refile to `org-gtd-incubate-file-basename'."
    (org-gtd--clarify-item)
    (goto-char (point-min))
    (org-gtd--refile-incubate))
  (defun org-gtd--quick-action ()
    "Process GTD inbox item by doing it now.
Allow the user apply user-defined tags from
`org-tag-persistent-alist', `org-tag-alist' or file-local tags in
the inbox.  Mark it as done and archive."
    (org-gtd--clarify-item)
    (goto-char (point-min))
    (org-todo "DONE")
    (org-archive-subtree))
  ;; for short term (today or tomorrow)
  (defun org-gtd--single-action ()
    "Process GTD inbox item as a single action.
Allow the user apply user-defined tags from
`org-tag-persistent-alist', `org-tag-alist' or file-local tags in
the inbox.  Set as a NEXT action and refile to
`org-gtd-actionable-file-basename'."
    (org-gtd--clarify-item)
    (goto-char (point-min))
    (org-schedule 0)
    (org-refile nil nil (org-gtd--refile-target org-gtd-actions)))
  :bind
  (("C-c d c" . org-gtd-capture) ;; add item to inbox
   ("C-c d a" . org-agenda-list) ;; see what's on your plate today
   ("C-c d p" . org-gtd-process-inbox) ;; process entire inbox
   ("C-c d n" . org-gtd-show-all-next) ;; see all NEXT items
   ("C-c d s" . org-gtd-show-stuck-projects)) ;; see projects that don't have a NEXT item
  :init
  (bind-key "C-c d d" 'org-gtd-clarify-finalize)) ;; the keybinding to hit when you're done editing an item in the processing phase

(use-package org-agenda
  :ensure nil ;; this is how you tell use-package to manage a sub-package
  :after org-gtd ;; because we need to add the org-gtd directory to the agenda files
  :custom
  ;; use as-is if you don't have an existing org-agenda setup
  ;; otherwise push the directory to the existing list
  ;; a useful view to see what can be accomplished today
  (org-agenda-custom-commands '(("g" "Scheduled today and all NEXT items" ((agenda "" ((org-agenda-span 1))) (todo "NEXT"))))))

(use-package org-capture
  :ensure nil
  ;; note that org-gtd has to be loaded before this
  :after org-gtd
  :config
  ;; use as-is if you don't have an existing set of org-capture templates
  ;; otherwise add to existing setup
  ;; you can of course change the letters, too
  ;;
  ;; https://www.zmonster.me/2018/02/28/org-mode-capture.html
  ;; http://blog.lujun9972.win/emacs-document/blog/2020/01/14/%E4%BD%BF%E7%94%A8emacs%EF%BC%8Corg-mode%EF%BC%8Canki-editor%E7%AD%89%E6%8F%92%E4%BB%B6%E5%90%AF%E5%8A%A8anki/index.html
  (setq org-my-anki-file "~/Syncthing/backup/org/anki.org")
  (setq org-capture-templates
        `(
          ("i" "Inbox"
           entry (file ,(org-gtd--path org-gtd-inbox-file-basename))
           "* %?\n%U\n\n  %i"
           :kill-buffer t)
          ("l" "Todo with link"
           entry (file ,(org-gtd--path org-gtd-inbox-file-basename))
           "* %?\n%U\n\n  %i\n  %a"
           :kill-buffer t)
          ;; ("t" "todo" entry (file+headline "" "todo") ; "" => `org-default-notes-file'
          ;;  "* NEXT %?\n%U\n" :clock-resume t)
          ;; ("n" "note" entry (file+headline "" "note")
          ;;  "* %? :NOTE:\n%U\n%a\n" :clock-resume t)
          ("b" "anki basic"
           entry
           (file+headline org-my-anki-file "dispatch shelf")
           "* %<%H:%M> %^g\n:PROPERTIES:\n:ANKI_NOTE_TYPE: 基础\n:ANKI_DECK: new\n:END:\n** 正面\n   %?\n** 背面\n   %x\n")
          ("c" "anki cloze"
           entry
           (file+headline org-my-anki-file "dispatch shelf")
           "* %<%H:%M> %^g\n:PROPERTIES:\n:ANKI_NOTE_TYPE: 填空题\n:ANKI_DECK: new\n:END:\n** 文字\n   %?%x\n** 额外的\n")
          ("e" "anki English"
           entry
           (file+headline org-my-anki-file "dispatch shelf")
           "* %<%H:%M>\n:PROPERTIES:\n:ANKI_NOTE_TYPE: foreign language\n:ANKI_DECK: English\n:END:\n** foreign language\n   %?\n** 意思\n** 例句\n   %x\n** 发音\n"))))

(use-package activity-watch-mode
  :ensure t
  :config
  (global-activity-watch-mode))

(provide 'init-local)
;;; init-local.el ends here
