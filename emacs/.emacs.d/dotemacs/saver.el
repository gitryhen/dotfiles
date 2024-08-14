(defun save-and-make ()
  (interactive)
  (save-some-buffers 1)
  (compile "make"))


;; make a new file with timestamp as filename
(defun my/file-by-date-with-inline-skeleton ()
    "Create file from skeleton with current time as name."
  (interactive)
  (find-file (format-time-string "~/Documents/Capture/%Y%m%d%H%M%S.txt"))
  (insert (format-time-string "Henry %Y%m%d\n")))

(defun my/org-file-by-date-with-inline-skeleton ()
    "Create file from skeleton with current time as name."
  (interactive)
  (find-file (format-time-string "~/Documents/Capture/%Y%m%d%H%M%S.org"))
  (insert (format-time-string "#+TITLE: %Y%m%d\n")))

(provide 'saver)
