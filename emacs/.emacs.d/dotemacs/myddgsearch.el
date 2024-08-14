(defun my/duckduckgo-search (text)
  "Search DuckDuckGo from Emacs."
  (interactive "sSearch: ")
  (browse-url
   (concat "https://lite.duckduckgo.com/lite?q="
           (replace-regexp-in-string " " "+" text))))

(provide 'myddgsearch)
