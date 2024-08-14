;; org-mode
(setq org-agenda-files '("~/OneDrive/Documents/gtd.org"
			 "~/OneDrive/Documents/inbox.org"
                         "~/OneDrive/Documents/tickler.org"
			 "~/OneDrive/Documents/nextactions.org"))
(setq org-capture-templates '(("t" "Todo [inbox]" entry
                               (file+headline "~/OneDrive/Documents/inbox.org" "Tasks")
                               "* TODO %i%? %a")
                              ("T" "Tickler" entry
                               (file+headline "~/OneDrive/Documents/tickler.org" "Tickler")
                               "* %i%? \n %T")
			      ("n" "next actions" checkitem
                               (file "~/OneDrive/Documents/nextactions.org")
                               "- [ ] %?\n")
			      ("j" "journal" entry
                               (file+datetree "~/OneDrive/Documents/journal.org")
                               "* %?\nEntered on %U\n  %i\n  %a \n %K %k \n")
			      ("a" "Appointment" entry
			       (file  "~/OneDrive/Documents/gcal.org" )
			       "* %?\n\n%^T\n\n:PROPERTIES:\n:calendar-id: henry.kelderman@gmail.com\n:END:\n\n")))
(setq org-refile-targets '(("~/OneDrive/Documents/gtd.org" :maxlevel . 1)
                           ("~/OneDrive/Documents/someday.org" :level . 1)
			   ("~/OneDrive/Documents//tickler.org" :maxlevel . 2)
			   ("~/OneDrive/Documents/references.org" :level . 1)
			   ("~/OneDrive/Documents/nextactions.org" :maxlevel . 3)))

;; https://koenig-haunstetten.de/2016/07/09/code-snippet-for-orgmode-e05s02/
(defun my/org-add-ids-to-headlines-in-file ()
  "Add ID properties to all headlines in the current file which
do not already have one."
  (interactive)
  (org-map-entries 'org-id-get-create))

(defun my/copy-id-to-clipboard() "Copy the ID property value to killring,
if no ID is there then create a new unique ID. 
This function works only in org-mode buffers.
 
The purpose of this function is to easily construct id:-links to 
org-mode items. If its assigned to a key it saves you marking the
text and copying to the killring."
       (interactive)
       (when (eq major-mode 'org-mode) ; do this only in org-mode buffers
     (setq mytmpid (funcall 'org-id-get-create))
     (kill-new mytmpid)
     (message "Copied %s to killring (clipboard)" mytmpid)))

(defun my/copy-idlink-to-clipboard() "Copy an ID link with the
headline to killring, if no ID is there then create a new unique
ID.  This function works only in org-mode or org-agenda buffers. 
 
The purpose of this function is to easily construct id:-links to 
org-mode items. If its assigned to a key it saves you marking the
text and copying to the killring."
       (interactive)
       (when (eq major-mode 'org-agenda-mode) ;switch to orgmode
     (org-agenda-show)
     (org-agenda-goto))       
       (when (eq major-mode 'org-mode) ; do this only in org-mode buffers
     (setq mytmphead (nth 4 (org-heading-components)))
         (setq mytmpid (funcall 'org-id-get-create))
     (setq mytmplink (format "[[id:%s][%s]]" mytmpid mytmphead))
     (kill-new mytmplink)
     (message "Copied %s to killring (clipboard)" mytmplink)
       ))
 
(provide 'orgstuff)
