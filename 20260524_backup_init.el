;; 20230829
;; 20230913 first straight.el
;; 20231220 clean up of recentf
;; 20240506 best default setting system crafters
;; 20240506 moved custom vars to dedicated file:custom-vars.el
;; 20250127 added xah-open-file on f9, but does not seem to work yet

(setq load-path (cons "~/.emacs.d/dotemacs/" load-path))
(prefer-coding-system 'utf-8)
(setq package-enable-at-startup nil)
(setq package-archives
      '(("gnu-elpa" . "https://elpa.gnu.org/packages/")
        ("gnu-elpa-devel" . "https://elpa.gnu.org/devel/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa" . "https://melpa.org/packages/")))

;; Highest number gets priority (what is not mentioned has priority 0)
(setq package-archive-priorities
      '(("gnu-elpa" . 2)
        ("melpa" . 3)
        ("nongnu" . 1)))

(setopt use-short-answers t)
(setq visible-bell t)
(setq bidi-paragraph-direction 'left-to-right)
(if (display-graphic-p)
    (setq initial-frame-alist
	  '((background-color . "honeydew"))))
(global-set-key (kbd "M-z") 'zap-up-to-char)
(global-set-key (kbd "C-x C-b") 'ibuffer)
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
(setq confirm-kill-processes nil)
(setq confirm-nonexistent-file-or-buffer nil)
(set-buffer-modified-p nil)
(add-hook 'kill-buffer-query-functions (lambda () (not-modified) t))
(electric-pair-mode) ;; auto parenthesis
(setq large-file-warning-threshold nil)
;; stop showing warnings
(setq warning-minimum-level :emergency)
(autoload 'save-and-make "saver")
(global-set-key (kbd "<f6>") 'save-and-make)
(autoload 'my/file-by-date-with-inline-skeleton "saver")
(global-set-key (kbd "<S-f12>") 'my/file-by-date-with-inline-skeleton)
(global-set-key (kbd "<f12>") 'denote)
(autoload 'xah-select-line "xah")
(delete-selection-mode 1) ;; type text replaces selected text
;;(autoload 'myddgsearch "my/duckduckgo-search")

(keymap-global-set "M-2" #'xah-select-line)
(keymap-global-set "M-3" #'xah-select-text-in-quote)

(defun xah-open-in-external-app (&optional Fname)
  "Open the current file or dired marked files in external app.
When called in emacs lisp, if Fname is given, open that.

URL `http://xahlee.info/emacs/emacs/emacs_dired_open_file_in_ext_apps.html'
Version: 2019-11-04 2023-04-05 2023-06-26"
  (interactive)
  (let (xfileList xdoIt)
    (setq xfileList
          (if Fname
              (list Fname)
            (if (eq major-mode 'dired-mode)
                (dired-get-marked-files)
              (list buffer-file-name))))
    (setq xdoIt (if (<= (length xfileList) 10) t (y-or-n-p "Open more than 10 files? ")))
    (when xdoIt
      (cond
       ((eq system-type 'windows-nt)
        (let ((xoutBuf (get-buffer-create "*xah open in external app*"))
              (xcmdlist (list "PowerShell" "-Command" "Invoke-Item" "-LiteralPath")))
          (mapc
           (lambda (x)
             (message "%s" x)
             (apply 'start-process (append (list "xah open in external app" xoutBuf) xcmdlist (list (format "'%s'" (if (string-match "'" x) (replace-match "`'" t t x) x))) nil)))
           xfileList)
          ;; (switch-to-buffer-other-window xoutBuf)
          )
        ;; old code. calling shell. also have a bug if filename contain apostrophe
        ;; (mapc (lambda (xfpath) (shell-command (concat "PowerShell -Command \"Invoke-Item -LiteralPath\" " "'" (shell-quote-argument (expand-file-name xfpath)) "'"))) xfileList)
        )
       ((eq system-type 'darwin)
        (mapc (lambda (xfpath) (shell-command (concat "open " (shell-quote-argument xfpath)))) xfileList))
       ((eq system-type 'gnu/linux)
        (mapc (lambda (xfpath)
                (call-process shell-file-name nil 0 nil
                              shell-command-switch
                              (format "%s %s"
                                      "xdg-open"
                                      (shell-quote-argument xfpath))))
              xfileList))
       ((eq system-type 'berkeley-unix)
        (mapc (lambda (xfpath) (let ((process-connection-type nil)) (start-process "" nil "xdg-open" xfpath))) xfileList))))))

(global-set-key (kbd "<f9>") 'xah-open-in-external-app)
(add-hook 'dired-mode-hook #'dired-hide-details-mode)
(add-hook 'text-mode-hook 'visual-line-mode)
;; emacselements.com
(setq ispell-program-name "c:/Ezwinports/bin/hunspell.exe")
(setq ispell-local-dictionary "en_US")
(setq ispell-local-dictionary-alist
    '(("en_US" "[[:alpha:]]" "[^[:alpha:]]" "[']" nil ("-d" "en_US") nil utf-8)))
(when (boundp 'ispell-hunspell-dictionary-alist)
  (setq ispell-hunspell-dictionary-alist ispell-local-dictionary-alist))
(setq hunspell-default-dict "en_US");; (setenv "DICPATH" "C:/Program Files/LibreOffice/share/extensions/dict-en")
;; (setenv "DICTIONARY" "en_US")
;; ;; (setenv "LANG" "en.UTF-8")
;; ;; ;; (setenv "DICPATH" "C:\\Program Files\\Emacs\\HunspellDict\\")
;; ;; ;; (setq ispell-local-dictionary "en_US")
;; (setq ispell-program-name "C:/Users/KeldermanH/AppData/Local/Microsoft/WinGet/Packages/FSFhu.Hunspell_Microsoft.Winget.Source_8wekyb3d8bbwe/hunspell.exe")
;; ;;(setq ispell-local-dictionary-alist
;;       '(("en" "[[:alpha:]]" "[^[:alpha:]]" "['’-]" nil ("-d" "en") nil utf-8)))
;; (setq ispell-local-dictionary-alist '(("en_US" "c:/Program Files/LibreOffice/share/extensions/dict-en")))

;; (use-package ess
;;   :ensure t
;;   :init
;;   (require 'ess-site)
;;   (setq org-babel-R-command "/usr/bin/R --no-save"))

;; ;; https://github.com/tompurl/dot-emacs/blob/master/emacs-init.org#spell-checking
;; (use-package flyspell
;;   :ensure t
;;   :init
;;   (add-hook 'org-mode-hook
;;             (lambda () (flyspell-mode 1))))
;; (setenv "LANG" "en.UTF-8")
;; (setenv "DICPATH" "C:\\Program Files\\Emacs\\HunspellDict\\")
;; (setq ispell-local-dictionary "en_US")
;; (setq ispell-local-dictionary-alist
;;       '(("en" "[[:alpha:]]" "[^[:alpha:]]" "['’-]" nil ("-d" "en") nil utf-8)))

;; (setq ispell-hunspell-dict-paths-alist
;;       '(("en_US" "C:\\Program Files\\Emacs\\HunspellDict\\index.aff")))

;; (setq ispell-personal-dictionary "C:\\Program Files\\Emacs\\HunspellDict\\.hunspell_personal")
;; (setq-default ispell-program-name "C:\\path\\AppData\\emacs\\Hunspell\\bin\\hunspell.exe")
;; (setq-default ispell-complete-word-dict "C:\\path\\AppData\\emacs\\dictionary\\english-words.txt")
;; (global-set-key (kbd "C-/") 'ispell-word)
;; (global-set-key (kbd "C-M-/") 'ispell-region)
;; (require 'flyspell)
;; (setq flyspell-issue-message-flag nil
;;       ispell-local-dictionary "en_US,nl"
;;       ispell-program-name "hunspell"
;;       ispell-extra-args '("--sug-mode=ultra"))
;; (add-hook 'text-mode-hook 'flyspell-mode)
;; (add-hook 'prog-mode-hook 'flyspell-prog-mode)
;; (define-key flyspell-mode-map (kbd "C-;") 'helm-flyspell-correct)

;; (use-package pyvenv
;;   :straight t
;;   :init
;;   (pyvenv-activate "/home/henry/venv"))

;; (use-package org-roam
;;   :ensure t
;;   :custom
;;   (org-roam-directory "~/OneDrive/Documents/orgroam")
;;   :config
;;   (org-roam-db-autosync-mode)
;;   (org-roam-setup))

;; (use-package org-ref
;;   :ensure t)

;; (use-package magit
;;   :straight t)

(use-package smex
  :ensure t
  :bind
  (("M-x" . smex)
   ("C-c C-j M-x" . execute-extended-command)))

;; (use-package ido-vertical-mode
;;   :ensure t
;;   :config
;;   (ido-mode 1)
;;   (ido-vertical-mode 1)
;;   (ido-everywhere t)
;;   (setq ido-vertical-define-keys 'C-n-and-C-p-only))

;; ;; this not work with consult
;; (use-package ido-ubiquitous
;;   :straight t
;;   :config
;;   (ido-ubiquitous 1))

(autoload 'ido-choose-from-recentf "myrecent")

(use-package recentf
  :ensure t
  :config
  (setq recentf-max-saved-items 24
	recent-max-menu-items 5)
  (recentf-mode t)
  ;;:bind
  ;;("C-x C-r" . consult-recent-file)
  :hook (after-init . recentf-mode))

(use-package init-open-recentf
  :after recentf
  :config
  (setq init-open-recentf-interface 'ido)
  (init-open-recentf))

(global-set-key (kbd "C-x C-r") 'ido-choose-from-recentf)
;;(global-set-key (kbd "C-x C-r") 'recentf-open-files)
;;(global-set-key (kbd "C-x C-r") 'consult-recent-file)

;; here was org
(require 'orgstuff)
;; ;; The following from Rainer Konig results in an error when saving
;; ;; as it asks to add missing non-existent-agenda file.
;; ;; so i add ids by hand and nog by saving
;; (add-hook 'org-mode-hook
;;           (lambda ()
;;             (add-hook 'before-save-hook 'my/org-add-ids-to-headlines-in-file nil 'local)))
(global-set-key (kbd "<f6>") 'my/copy-id-to-clipboard)
(global-set-key (kbd "<f7>") 'my/copy-idlink-to-clipboard)
(global-set-key (kbd "<f8>") 'my/org-add-ids-to-headlines-in-file)
(setq org-adapt-indentation nil)
(setq org-duration-format (quote h:mm))
(setq org-id-link-to-org-use-id t)
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c b") 'org-iswitchb)
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c r") 'org-refile)
;; autosave after refile
(setq org-reverse-note-order t)
(advice-add 'org-refile :after #'org-save-all-org-buffers)


;; (use-package slime
;;   :ensure t
;;   :init
;;   (slime-setup '(slime-fancy))
;;   :config
;;   (setq inferior-lisp-program "/usr/bin/sbcl"))

;; (use-package tex
;;   :straight auctex
;;   :defer t)

;; luceda python werkt niet goed, doet 1 keer 2e keer aanroepen duurt lang <2026-03-05 Thu>

;; (use-package pyvenv
;;   :ensure t
;;   :config
;;   ;; (setenv "WORKON_HOME" "C:/users/KeldermanH/venv")  ;; Set this to your virtual environment directory
;;   (setenv "WORKON_HOME" "C:/luceda/luceda_2025120/envs/ipkiss3")  ;; Set this to your virtual environment directory
;;   (pyvenv-mode 1)
;;   :init
;;   ;; (pyvenv-activate "C:/users/KeldermanH/venv"))
;;   (pyvenv-activate "C:/luceda/luceda_2025120/envs/ipkiss3"))

;; (setq python-shell-interpreter "python"
;;       python-shell-interpreter-interactive-arg "-i -u")

;; ;; 20260224


;; 20260616
(setq python-shell-interpreter "ipython"
      python-shell-interpreter-interactive-arg "-i --simple-prompt")

(use-package pyvenv
  :ensure t
  :config
  (setenv "WORKON_HOME" "C:/users/KeldermanH/venv")  ;; Set this to your virtual environment directory
  (pyvenv-mode 1)
  :init
  (pyvenv-activate "C:/users/KeldermanH/venv"))



;; (use-package pyenv-mode
;;   :ensure t
;;   :init
;; ;;  (add-to-list 'exec-path "~/.pyenv/shims")
;;   (setenv "WORKON_HOME" "C:/luceda/luceda_2025120/envs/ipkiss3")
;;   :config
;;   (pyenv-mode))

;; (use-package pyconf
;;   :ensure t)

;; (defalias 'workon 'pyvenv-workon)

(use-package python-black
  :ensure t
  :demand t
  :after python
  :hook ((python-mode . python-black-on-save-mode)))


;; ;; (setq python-shell-interpreter "ipython"
;; ;;       python-shell-interpreter-args "-i --simple-prompt")
;; ;; (use-package pyvenv
;; ;;   :ensure t
;; ;;   :init
;; ;;   (pyvenv-activate "C:/Users/KeldermanH/venv"))

;; (use-package blacken
;;   :ensure t
;;   :hook (python-mode . blacken-mode))

(use-package which-key
  :ensure t
  :config
  (which-key-mode t))

(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-mode))

;; ;; (use-package vertico
;; ;;   :ensure t
;; ;;   :init
;; ;;   :config
;; ;;   (setq vertico-cycle t)
;; ;;   (setq vertico-resize nil)
;; ;;   (vertico-mode 1))

(use-package vertico
  :ensure t
  :custom
  (vertico-scroll-margin 0) ;; Different scroll margin
  ;; (vertico-count 20) ;; Show more candidates
  (vertico-resize t) ;; Grow and shrink the Vertico minibuffer
  (vertico-cycle t) ;; Enable cycling for `vertico-next/previous'
  :init
  (vertico-mode))

(use-package marginalia
  :ensure t
  :config
  (marginalia-mode 1))

;; (use-package consult
;;   :ensure t
;;   :hook (completion-list-mode . consult-preview-at-point-mode)
;;   :init
;;   :bind
;;   ("C-x b" . consult-buffer))


;; ;; source: https://andrewfavia.dev/posts/emacs-as-python-ide-again/
;; ;; (when use-company
;; (use-package company
;;   :ensure t
;;   :hook ((prog-mode . company-mode))
;;   :bind (:map company-active-map
;;               ("<return>" . nil)
;;               ("RET" . nil)
;;               ("C-<return>" . company-complete-selection)
;;               ([tab] . company-complete-selection)
;;               ("TAB" . company-complete-selection)))

;; (use-package company-box
;;   :ensure t
;;   :hook (company-mode . company-box-mode))


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
  (corfu-history-mode)
  :bind
  (:map corfu-map
        ("TAB" . corfu-insert)
        ([tab] . corfu-insert)
        ("C-n" . corfu-next)
        ("C-p" . corfu-previous)))

;; Optionally use the `orderless' completion style.
(use-package orderless
  :ensure t
  :custom
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (orderless-style-dispatchers '(+orderless-consult-dispatch orderless-affix-dispatch))
  ;; (orderless-component-separator #'orderless-escapable-split-on-space)
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles basic partial-completion)))))


;; Use Dabbrev with Corfu! switched to cape, does it work?
(use-package dabbrev
  :ensure t
  ;; Swap M-/ and C-M-/
  :bind (("M-/" . hippie-expand)
         ("C-M-/" . dabbrev-completion))
  ;; Other useful Dabbrev configurations.
  :custom
  (dabbrev-ignored-buffer-regexps '("\\.\\(?:pdf\\|jpe?g\\|png\\)\\'")))

(use-package cape
  :ensure t
  ;; Bind prefix keymap providing all Cape commands under a mnemonic key.
  ;; Press C-c p ? to for help.
  :bind ("C-c p" . cape-prefix-map) ;; Alternative key: M-<tab>, M-p, M-+
  ;; Alternatively bind Cape commands individually.
  ;; :bind (("C-c p d" . cape-dabbrev)
  ;;        ("C-c p h" . cape-history)
  ;;        ("C-c p f" . cape-file)
  ;;        ...)
  :init
  ;; Add to the global default value of `completion-at-point-functions' which is
  ;; used by `completion-at-point'.  The order of the functions matters, the
  ;; first function returning a result wins.  Note that the list of buffer-local
  ;; completion functions takes precedence over the global list.
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-elisp-block)
  ;; (add-hook 'completion-at-point-functions #'cape-history)
  ;; ...
)

;; (use-package yasnippet
;;   :ensure t
;;   :config
;;   (yas-global-mode t))

;; (use-package yasnippet-snippets
;;   :ensure t)

;; (use-package eglot
;;   :ensure t
;;   :defer t
;;   :hook ((python-mode . eglot-ensure))
;;   :config
;;   (straight-use-package 'project)
;;   (require 'project)
;;   (add-to-list 'eglot-server-programs
;;                `(python-mode . ("python-lsp-server"))))
;;                  . ,(eglot-alternatives '(("pyright-langserver" "--stdio")
;;                                           "jedi-language-server"
;;                                           "pylsp")))))

;; ;; corfu eglot
;; (setq completion-category-overrides '((eglot (styles orderless))
;;                                       (eglot-capf (styles orderless))))

;; (use-package lsp-mode
;;   :ensure t
;;   :config
;;   (require 'lsp-mode)
;;   (add-hook 'python-mode-hook 'lsp))

;; (use-package lsp-ui
;;   :ensure t
;;   :config
;;   (add-hook 'lsp-mode-hook 'lsp-ui-mode))

;; ;; (use-package company-lsp
;; ;;   :ensure t
;; ;;   :config
;; ;;   (push 'company-lsp company-backends))

;; (defun lsp-set-cfg ()
;;   (let ((lsp-cfg `(:pyls (:configurationSources (\"flake8\")))))
;;     (lsp--set-configuration lsp-cfg)))

;; (add-hook 'lsp-after-initialize-hook 'lsp-set-cfg)


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

(use-package denote
  :ensure t)

(use-package denote-journal
  :ensure t
  :commands ( denote-journal-new-entry
              denote-journal-new-or-existing-entry
              denote-journal-link-or-create-entry )
  :hook (calendar-mode . denote-journal-calendar-mode)
  :config
  ;; Use the "journal" subdirectory of the `denote-directory'.  Set this
  ;; to nil to use the `denote-directory' instead.
  (setq denote-journal-directory
        (expand-file-name "journal" denote-directory))
  ;; Default keyword for new journal entries. It can also be a list of
  ;; strings.
  (setq denote-journal-keyword "journal")
  ;; Read the doc string of `denote-journal-title-format'.
  (setq denote-journal-title-format 'day-date-month-year)
  (add-hook 'calendar-mode-hook #'denote-journal-calendar-mode))

;; (use-package mu4e
;;   :ensure nil
;;   :defer 5
;;   :load-path "/usr/share/emacs/site-lisp/mue4/"
;;   :config
;;   (require 'org-mu4e)

;;   ;; refresh mbsync every 10 minutes
;;   (setq mu4e-update-interval (* 10 60))
;;   (setq mu4e-get-mail-command "mbsync -a")
;;   (setq mu4e-maildir (expand-file-name "~/Mail"))
;;   ;; use pass to store passwords
;;   ;; file auth looks for is ~/.password-store/<smtp.host.tld>:<port>/<name>
;;   (auth-source-pass-enable)
;;   (setq auth-sources '(password-store))
;;   (setq auth-source-debug t)
;;   (setq auth-source-do-cache nil)
;;   ;; no reply to self
;;   (setq mu4e-compose-dont-reply-to-self t)
;;   (setq mu4e-compose-keep-self-cc nil)
;;   ;; moving messages renames files to avoid errors
;;   (setq mu4e-change-filenames-when-moving t)
;;   ;; Configure the function to use for sending mail
;;   (setq message-send-mail-function 'smtpmail-send-it)
;;   ;; Display options
;;   (setq mu4e-view-show-images t)
;;   (setq mu4e-view-show-addresses 't)
;;   ;; Composing mail
;;   (setq mu4e-compose-dont-reply-to-self t)
;;   ;; don't keep message buffers around
;;   (setq message-kill-buffer-on-exit t)
;;   ;; Don't ask for a 'context' upon opening mu4e
;;   (setq mu4e-context-policy 'pick-first)
;;   ;; Don't ask to quit... why is this the default?
;;   (setq mu4e-confirm-quit nil)

;;   ;; Set up contexts for email accounts
;;   ;; (setq mu4e-contexts
;;   ;;       (list
;;   ;;        (make-mu4e-context
;;   ;;         :name "<mail account name>"
;;   ;;         :match-func
;;   ;;     (lambda (msg)
;;   ;;           (when msg
;;   ;;             (string-prefix-p "/<mail account dir>" (mu4e-message-field msg :maildir))))
;;   ;;         :vars `((user-mail-address . "<mail address>")
;;   ;;                 (user-full-name    . "<mail full name>")
;;   ;;                 (smtpmail-smtp-server  . "<smtp.host.tld>")
;;   ;;                 (smtpmail-smtp-service . "<smtp port>")
;;   ;;                 (smtpmail-stream-type  . ssl)
;;   ;;                 (smtpmail-smtp-user . "<email username>")
;;   ;;                 (mu4e-compose-signature . "<email signature>")
;;   ;;                 (mu4e-drafts-folder  . "<mail account dir>/<draft dir>")
;;   ;;                 (mu4e-sent-folder  . "<mail account dir>/<sent dir>")
;;   ;;                 (mu4e-refile-folder  . "<mail account dir>/<archive dir>")
;;   ;;                 (mu4e-trash-folder  . "<mail account dir>/<trash dir>")))))

;;   ;; (setq m/mu4e-inbox-query
;;   ;;       "(maildir:/<mail account dir>/<inbox dir>) AND flag:unread")
;;   ;; (defun m/go-to-inbox ()
;;   ;;   (interactive)
;;   ;;   (mu4e-headers-search m/mu4e-inbox-query))
;;   ;; start mu4e
;;   (mu4e t))

;; (use-package gruvbox-theme
;;   :ensure t)

(use-package auctex
  :ensure t)

(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-AUCTeX t)

(use-package evil
  :ensure t
  :config
  (evil-mode 1)
  :bind
  (("<f5>" . evil-mode)))

(use-package dired-efap
  :ensure t
  :bind
  (:map dired-mode-map
	("<f2>" . dired-efap)))

(use-package magit
  :ensure t)

(use-package sr-speedbar
  :ensure t
  :custom
  (sr-speedbar-width-x 15)
  (sr-speedbar-skip-other-window-p t))

;; ;;; treemacs
;; (use-package treemacs
;;   :ensure t
;;   :defer t
;;   :init
;;   (with-eval-after-load 'winum
;;     (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
;;   :config
;;   (progn
;;     (setq treemacs-buffer-name-function            #'treemacs-default-buffer-name
;;           treemacs-buffer-name-prefix              " *Treemacs-Buffer-"
;;           treemacs-collapse-dirs                   (if treemacs-python-executable 3 0)
;;           treemacs-deferred-git-apply-delay        0.5
;;           treemacs-directory-name-transformer      #'identity
;;           treemacs-display-in-side-window          t
;;           treemacs-eldoc-display                   'simple
;;           treemacs-file-event-delay                2000
;;           treemacs-file-extension-regex            treemacs-last-period-regex-value
;;           treemacs-file-follow-delay               0.2
;;           treemacs-file-name-transformer           #'identity
;;           treemacs-follow-after-init               t
;;           treemacs-expand-after-init               t
;;           treemacs-find-workspace-method           'find-for-file-or-pick-first
;;           treemacs-git-command-pipe                ""
;;           treemacs-goto-tag-strategy               'refetch-index
;;           treemacs-header-scroll-indicators        '(nil . "^^^^^^")
;;           treemacs-hide-dot-git-directory          t
;;           treemacs-hide-dot-jj-directory           t
;;           treemacs-indentation                     2
;;           treemacs-indentation-string              " "
;;           treemacs-is-never-other-window           nil
;;           treemacs-max-git-entries                 5000
;;           treemacs-missing-project-action          'ask
;;           treemacs-move-files-by-mouse-dragging    t
;;           treemacs-move-forward-on-expand          nil
;;           treemacs-no-png-images                   nil
;;           treemacs-no-delete-other-windows         t
;;           treemacs-project-follow-cleanup          nil
;;           treemacs-persist-file                    (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
;;           treemacs-position                        'left
;;           treemacs-read-string-input               'from-child-frame
;;           treemacs-recenter-distance               0.1
;;           treemacs-recenter-after-file-follow      nil
;;           treemacs-recenter-after-tag-follow       nil
;;           treemacs-recenter-after-project-jump     'always
;;           treemacs-recenter-after-project-expand   'on-distance
;;           treemacs-litter-directories              '("/node_modules" "/.venv" "/.cask")
;;           treemacs-project-follow-into-home        nil
;;           treemacs-show-cursor                     nil
;;           treemacs-show-hidden-files               t
;;           treemacs-silent-filewatch                nil
;;           treemacs-silent-refresh                  nil
;;           treemacs-sorting                         'alphabetic-asc
;;           treemacs-select-when-already-in-treemacs 'move-back
;;           treemacs-space-between-root-nodes        t
;;           treemacs-tag-follow-cleanup              t
;;           treemacs-tag-follow-delay                1.5
;;           treemacs-text-scale                      nil
;;           treemacs-user-mode-line-format           nil
;;           treemacs-user-header-line-format         nil
;;           treemacs-wide-toggle-width               70
;;           treemacs-width                           35
;;           treemacs-width-increment                 1
;;           treemacs-width-is-initially-locked       t
;;           treemacs-workspace-switch-cleanup        nil)

;;     ;; The default width and height of the icons is 22 pixels. If you are
;;     ;; using a Hi-DPI display, uncomment this to double the icon size.
;;     ;;(treemacs-resize-icons 44)

;;     (treemacs-follow-mode t)
;;     (treemacs-filewatch-mode t)
;;     (treemacs-fringe-indicator-mode 'always)
;;     (when treemacs-python-executable
;;       (treemacs-git-commit-diff-mode t))

;;     (pcase (cons (not (null (executable-find "git")))
;;                  (not (null treemacs-python-executable)))
;;       (`(t . t)
;;        (treemacs-git-mode 'deferred))
;;       (`(t . _)
;;        (treemacs-git-mode 'simple)))

;;     (treemacs-hide-gitignored-files-mode nil))
;;   :bind
;;   (:map global-map
;;         ("M-0"       . treemacs-select-window)
;;         ("C-x t 1"   . treemacs-delete-other-windows)
;;         ("C-x t t"   . treemacs)
;;         ("C-x t d"   . treemacs-select-directory)
;;         ("C-x t B"   . treemacs-bookmark)
;;         ("C-x t C-t" . treemacs-find-file)
;;         ("C-x t M-t" . treemacs-find-tag)))

;; (use-package treemacs-projectile
;;   :after (treemacs projectile)
;;   :ensure t)

;; (use-package treemacs-icons-dired
;;   :hook (dired-mode . treemacs-icons-dired-enable-once)
;;   :ensure t)

;; (use-package treemacs-magit
;;   :after (treemacs magit)
;;   :ensure t)

;; (treemacs-start-on-boot)
;;; treemacs

;; set path to mingw
(setenv "PATH" (concat "C:\\MinGW\\bin;" (getenv "PATH")))
(setq exec-path (cons "C:\\MinGW\\bin" exec-path))

(defun my-org-confirm-babel-evaluate (lang body)
  (not (string= lang "python")))  ;don't ask for confirmation executing python code
(setq org-confirm-babel-evaluate #'my-org-confirm-babel-evaluate)

(use-package yasnippet
  :ensure t
  :hook ((prog-mode text-mode conf-mode) . yas-minor-mode))

(use-package yasnippet-snippets
  :ensure t
  :after yasnippet
  :config
  (yas-reload-all))

(setq custom-file (locate-user-emacs-file "custom-vars.el"))
(load custom-file 'no-error 'no-message)
