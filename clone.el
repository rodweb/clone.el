(defgroup clone nil
  "A simple tool for cloning git repositories."
  :prefix "clone-"
  :group 'tools)

(defcustom clone-function
  'magit-clone-regular
  "Function used to clone a repository.")

(defcustom clone-protocol
  'https
  "Default protocol used for cloning."
  :type 'symbol)

(defcustom clone-directory
  nil
  "Default directory to clone to."
  :type 'directory)

(defcustom clone-default-host
  "github.com"
  "Default host used for cloning."
  :type 'string)

(defcustom clone-hook
  nil
  "Hook for `clone-repo' function."
  :type 'hook)

(defun clone-repo (url &optional dir)
  "Clone git repository from URL to DIR."
  (interactive (list (read-string "Repository URL: ")
                     (or clone-directory (read-string "Directory: " default-directory))))
  (let* ((info (clone--parse-url url))
         (host (or (plist-get info :host) clone-default-host))
         (user (plist-get info :user))
         (repo (plist-get info :repo)))
    (if (eq clone-protocol 'ssh)
        (clone--internal (concat "git@" host ":" user "/" repo ".git") (concat dir "/" repo))
      (clone--internal (concat "https://" host "/" user "/" repo ".git") (concat dir "/" repo)))))

(defun clone--parse-url (url)
  (string-match "^\\(\\(git@\\|https:\/\/\\)\\([^:\/]+\\)[:\/]\\)?\\([^\/]+\\)\/\\([^\/]+?\\)\\(\.git\\)?$" url)
  (when (match-string 0 url)
    (list :host (match-string 3 url)
          :user (match-string 4 url)
          :repo (match-string 5 url))))

(defun clone--internal (repo dir)
  (funcall clone-function repo dir nil)
  (run-hooks 'clone-hook))

(provide 'clone)
