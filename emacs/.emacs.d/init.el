;; 20230829
;; 20230913 first straight.el
;; 20231220 clean up of recentf
;; 20240506 best default setting system crafters
;; 20240506 moved custom vars to dedicated file:custom-vars.el

(setq load-path (cons "~/.emacs.d/dotemacs/" load-path))
(prefer-coding-system 'utf-8)
(setq package-enable-at-startup nil)
;; (defvar bootstrap-version)
;; (let ((bootstrap-file
;;        (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
;;       (bootstrap-version 6))
;;   (unless (file-exists-p bootstrap-file)
;;     (with-current-buffer
;;         (url-retrieve-synchronously
;;          "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
;;          'silent 'inhibit-cookies)
;;       (goto-char (point-max))
;;       (eval-print-last-sexp)))
;;   (load bootstrap-file nil 'nomessage))
;; (straight-use-package 'use-package)
;; yes-or-no-p replaced

;; Also read: <https://protesilaos.com/codelog/2022-05-13-emacs-elpa-devel/>
(setq package-archives
      '(("gnu-elpa" . "https://elpa.gnu.org/packages/")
        ("gnu-elpa-devel" . "https://elpa.gnu.org/devel/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa" . "https://melpa.org/packages/")))

;; Highest number gets priority (what is not mentioned has priority 0)
(setq package-archive-priorities
      '(("gnu-elpa" . 3)
        ("melpa" . 2)
        ("nongnu" . 1)))

(setopt use-short-answers t)
(setq visible-bell nil)
(setq bidi-paragraph-direction 'left-to-right)
(if (display-graphic-p)
    (setq initial-frame-alist
	  '((background-color . "honeydew"))))
(global-set-key "\M-z" 'zap-up-to-char)
(setq backup-directory-alist '(("." . "~/Backup")))
(with-eval-after-load 'tramp
(add-to-list 'tramp-backup-directory-alist
             (cons tramp-file-name-regexp nil)))
(setq savehist-file "~/Backup/emacssavehistory")
(savehist-mode 1)
(setq history-length 50)
(setq history-delete-duplicates t)
(setq savehist-save-minibuffer-history 1)
(setq savehist-additional-variables
      '(kill-ring
        search-ring
        regexp-search-ring))
(save-place-mode 1)
(setq use-dialog-box nil)
(global-auto-revert-mode 1)

;; improve(d) backup
(setq backup-directory-alist '(("." . "~/.config/emacs/backups")))
(setq delete-old-version -1)
(setq version-control t)
(setq vc-make-backup-files t)
(setq delete-old-versions t)
(setq auto-save-file-name-transforms '((".*" "~/.config/emacs/auto-save-list/" t)))
(setq system-trash-exclude-matches '("#[^/]+#$" ".*~$" "\\.emacs\\.desktop.*"))
(setq system-trash-exclude-paths '("/tmp"))
(setq delete-by-moving-to-trash t)
;; stop prompting
;; source https://www.youtube.com/watch?v=ZFJlxBPvzE0 wretchedness of confirmation in emacs
(setq dired-confirm-shell-command nil)
(setq dired-no-confirm t)
(setq dired-recursive-deletes (quote always))
(setq dired-deletion-confirmer '(lambda (x) t))
(setq confirm-kill-emacs nil)
(setq confirm-kill-processes nil)
(setq confirm-nonexistent-file-or-buffer nil)
(set-buffer-modified-p nil)
(add-hook 'kill-buffer-query-functions (lambda () (not-modified) t))
(electric-pair-mode)
(setq large-file-warning-threshold nil)
;; stop showing warnings
(setq warning-minimum-level :emergency)
(autoload 'save-and-make "saver")
(global-set-key (kbd "<f6>") 'save-and-make)
(autoload 'my/file-by-date-with-inline-skeleton "saver")
(global-set-key (kbd "<f12>") 'my/file-by-date-with-inline-skeleton)
(autoload 'xah-select-line "xah")
(autoload 'myddgsearch "my/duckduckgo-search")

(keymap-global-set "M-2" #'xah-select-line)
(keymap-global-set "M-3" #'xah-select-text-in-quote)

;; (use-package ess
;;   :ensure t
;;   :init
;;   (require 'ess-site)
;;   (setq org-babel-R-command "/usr/bin/R --no-save"))


(require 'flyspell)
(setq flyspell-issue-message-flag nil
      ispell-local-dictionary "en_US,nl"
      ispell-program-name "aspell"
      ispell-extra-args '("--sug-mode=ultra"))
(add-hook 'text-mode-hook 'flyspell-mode)
(add-hook 'prog-mode-hook 'flyspell-prog-mode)
(define-key flyspell-mode-map (kbd "C-;") 'helm-flyspell-correct)

(use-package pyvenv
  :ensure t
  :init
  (pyvenv-activate "/home/henry/venv"))

;; (use-package org-roam
;;   :ensure t
;;   :custom
;;   (org-roam-directory "~/OneDrive/Documents/orgroam")
;;   :config
;;   (org-roam-db-autosync-mode)
;;   (org-roam-setup))

;; (use-package org-ref
;;   :ensure t)

(use-package notmuch
  :ensure t
  :config
  (setq notmuch-search-oldest-first nil))

(use-package magit
  :ensure t)

(use-package smex
  :ensure t
  :bind
  (("M-x" . smex)
  ("C-c C-c M-x" . execute-extended-command)))

(use-package ido-vertical-mode
  :ensure t
  :config
  (ido-mode 1)
  (ido-vertical-mode 1)
  (ido-everywhere t)
  (setq ido-vertical-define-keys 'C-n-and-C-p-only))

;; ;; this not work with consult
;; (use-package ido-ubiquitous
;;   :ensure t
;;   :config
;;   (ido-ubiquitous 1))

(autoload 'ido-choose-from-recentf "myrecent")

(use-package recentf
  :ensure t
  :config
  (setq recentf-max-saved-items 24
	recent-max-menu-items 5)
  (recentf-mode t)
  :bind
  ("C-x C-r" . ido-choose-from-recentf)
  ;;("C-x C-r" . consult-recent-file)
  :hook (after-init . recentf-mode))

(use-package init-open-recentf
      :after recentf
      :config (init-open-recentf))

;;(global-set-key (kbd "C-x C-r") 'ido-choose-from-recentf)

;; here was org
(require 'orgstuff)
;; ;; The following from Rainer Konig results in an error when saving
;; ;; as it asks to add missing non-existent-agenda file.
;; ;; so i add ids by hand and nog by saving
;; (add-hook 'org-mode-hook
;;           (lambda ()
;;             (add-hook 'before-save-hook 'my/org-add-ids-to-headlines-in-file nil 'local)))
(global-set-key (kbd "<f7>") 'my/copy-id-to-clipboard)
(global-set-key (kbd "<f8>") 'my/copy-idlink-to-clipboard)
(global-set-key (kbd "<f9>") 'my/org-add-ids-to-headlines-in-file)
(setq org-adapt-indentation nil)
(setq org-duration-format (quote h:mm))
(setq org-id-link-to-org-use-id t)
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c b") 'org-iswitchb)
(global-set-key (kbd "C-c c") 'org-capture)

(use-package vertico
  :ensure t
  :init
  :config
  (setq vertico-cycle t)
  (setq vertico-resize nil)
  (vertico-mode 1))


(use-package consult
  :ensure t
  :hook (completion-list-mode . consult-preview-at-point-mode)
  :init
  :bind
  ("C-x b" . consult-buffer))

(use-package consult-ag
  :ensure t)

;; (use-package ag
;;   :ensure t)

(use-package marginalia
  :ensure t
  :config
  (marginalia-mode 1))


(use-package slime
  :ensure t
  :init
  (slime-setup '(slime-fancy))
  :config
  (setq inferior-lisp-program "/usr/bin/sbcl"))

;; (use-package tex
;;   :straight auctex
;;   :defer t)

(use-package which-key
  :ensure t
  :config
  (which-key-mode t))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-mode))

(use-package corfu
  :ensure t
  :custom
  (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
  (corfu-auto t)                 ;; Enable auto completion
  (corfu-separator ?\s)          ;; Orderless field separator
  (corfu-quit-at-boundary nil)   ;; Never quit at completion boundary
  (corfu-quit-no-match t)      ;; Never quit, even if there is no match
  (corfu-preview-current nil)    ;; Disable current candidate preview
  (corfu-preselect 'prompt)      ;; Preselect the prompt
  (corfu-on-exact-match nil)     ;; Configure handling of exact matches
  (corfu-scroll-margin 5)        ;; Use scroll margin

  ;; ;; Enable Corfu only for certain modes.
  ;; :hook ((prog-mode . corfu-mode)
  ;;        (shell-mode . corfu-mode)
  ;;        (eshell-mode . corfu-mode))

  ;; Recommended: Enable Corfu globally.  This is recommended since Dabbrev can
  ;; be used globally (M-/).  See also the customization variable
  ;; `global-corfu-modes' to exclude certain modes.
  :init
  (setf corfu-auto t)
  (global-corfu-mode)
  (corfu-history-mode))

;; Use Dabbrev with Corfu!
(use-package dabbrev
  ;; Swap M-/ and C-M-/
  :bind (("M-/" . dabbrev-completion)
         ("C-M-/" . dabbrev-expand))
  ;; Other useful Dabbrev configurations.
  :custom
  (dabbrev-ignored-buffer-regexps '("\\.\\(?:pdf\\|jpe?g\\|png\\)\\'")))

;; ;; A few more useful configurations...
;; (use-package emacs
;;   :init
;;   ;; TAB cycle if there are only few candidates
;;   (setq completion-cycle-threshold 3)

;;   ;; Emacs 28: Hide commands in M-x which do not apply to the current mode.
;;   ;; Corfu commands are hidden, since they are not supposed to be used via M-x.
;;   ;; (setq read-extended-command-predicate
;;   ;;       #'command-completion-default-include-p)

;;   ;; Enable indentation+completion using the TAB key.
;;   ;; `completion-at-point' is often bound to M-TAB.
;;   (setq tab-always-indent 'complete))


(use-package mu4e
  :ensure nil
  :defer 5
  :load-path "/usr/share/emacs/site-lisp/mue4/"
  :config
  (require 'org-mu4e)

  ;; refresh mbsync every 10 minutes
  (setq mu4e-update-interval (* 10 60))
  (setq mu4e-get-mail-command "mbsync -a")
  (setq mu4e-maildir (expand-file-name "~/Mail"))
  ;; use pass to store passwords
  ;; file auth looks for is ~/.password-store/<smtp.host.tld>:<port>/<name>
  (auth-source-pass-enable)
  (setq auth-sources '(password-store))
  (setq auth-source-debug t)
  (setq auth-source-do-cache nil)
  ;; no reply to self
  (setq mu4e-compose-dont-reply-to-self t)
  (setq mu4e-compose-keep-self-cc nil)
  ;; moving messages renames files to avoid errors
  (setq mu4e-change-filenames-when-moving t)
  ;; Configure the function to use for sending mail
  (setq message-send-mail-function 'smtpmail-send-it)
  ;; Display options
  (setq mu4e-view-show-images t)
  (setq mu4e-view-show-addresses 't)
  ;; Composing mail
  (setq mu4e-compose-dont-reply-to-self t)
  ;; don't keep message buffers around
  (setq message-kill-buffer-on-exit t)
  ;; Don't ask for a 'context' upon opening mu4e
  (setq mu4e-context-policy 'pick-first)
  ;; Don't ask to quit... why is this the default?
  (setq mu4e-confirm-quit nil)

  ;; Set up contexts for email accounts
  ;; (setq mu4e-contexts
  ;;       (list
  ;;        (make-mu4e-context
  ;;         :name "<mail account name>"
  ;;         :match-func
  ;;     (lambda (msg)
  ;;           (when msg
  ;;             (string-prefix-p "/<mail account dir>" (mu4e-message-field msg :maildir))))
  ;;         :vars `((user-mail-address . "<mail address>")
  ;;                 (user-full-name    . "<mail full name>")
  ;;                 (smtpmail-smtp-server  . "<smtp.host.tld>")
  ;;                 (smtpmail-smtp-service . "<smtp port>")
  ;;                 (smtpmail-stream-type  . ssl)
  ;;                 (smtpmail-smtp-user . "<email username>")
  ;;                 (mu4e-compose-signature . "<email signature>")
  ;;                 (mu4e-drafts-folder  . "<mail account dir>/<draft dir>")
  ;;                 (mu4e-sent-folder  . "<mail account dir>/<sent dir>")
  ;;                 (mu4e-refile-folder  . "<mail account dir>/<archive dir>")
  ;;                 (mu4e-trash-folder  . "<mail account dir>/<trash dir>")))))

  ;; (setq m/mu4e-inbox-query
  ;;       "(maildir:/<mail account dir>/<inbox dir>) AND flag:unread")
  ;; (defun m/go-to-inbox ()
  ;;   (interactive)
  ;;   (mu4e-headers-search m/mu4e-inbox-query))
  ;; start mu4e
  (mu4e t))

(use-package gruvbox-theme
  :ensure t)

(setq custom-file (locate-user-emacs-file "custom-vars.el"))
(load custom-file 'no-error 'no-message)
