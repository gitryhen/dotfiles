(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(blink-cursor-mode nil)
 '(custom-enabled-themes '(gruvbox-light-hard))
 '(custom-safe-themes
   '("75b371fce3c9e6b1482ba10c883e2fb813f2cc1c88be0b8a1099773eb78a7176" "a5270d86fac30303c5910be7403467662d7601b821af2ff0c4eb181153ebfc0a" "046a2b81d13afddae309930ef85d458c4f5d278a69448e5a5261a5c78598e012" default))
 '(electric-pair-mode t)
 '(ido-mode 'both nil (ido))
 '(newsticker-url-list
   '(("nos nieuws" "https://feeds.nos.nl/nosnieuwsalgemeen" nil nil nil)
     ("zerohedge" "http://feeds.feedburner.com/zerohedge/feed" nil nil nil)))
 '(notmuch-saved-searches
   '((:name "inbox" :query "tag:inbox" :key "i")
     (:name "unread" :query "tag:unread" :key "u")
     (:name "flagged" :query "tag:flagged" :key "f")
     (:name "sent" :query "tag:sent" :key "t")
     (:name "drafts" :query "tag:draft" :key "d")
     (:name "all mail" :query "*" :key "a")
     (:name "01" :query "bol.com")))
 '(org-babel-load-languages
   '((python . t)
     (perl . t)
     (emacs-lisp . t)
     (R . t)
     (awk . t)
     (gnuplot . t)
     (latex . t)
     (dot . t)))
 '(org-confirm-babel-evaluate nil)
 '(org-fold-core-style 'overlays)
 '(org-id-locations-file "~/OneDrive/Documents/.org-id-locations")
 '(package-selected-packages '(notmuch bbdb bbdb3 mu4e ido-vertical-mode))
 '(send-mail-function 'mailclient-send-it)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "JetBrainsMonoNL Nerd Font" :foundry "JB" :slant normal :weight regular :height 105 :width normal)))))
(put 'set-goal-column 'disabled nil)
