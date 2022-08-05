(require 'ert)
(require 'clone)

(ert-deftest test-clone-http ()
  "Should clone repository via HTTP."
  (setq-local clone-function (lambda (command) command))
  (should
   (equal
    (clone-repo "rodweb/clone.el")
    "git clone https://github.com/rodweb/clone.el.git"))
  (should
   (equal
    (clone-repo "git@github.com:rodweb/clone.el.git")
    "git clone https://github.com/rodweb/clone.el.git"))
  (should
   (equal
    (clone-repo "https://github.com/rodweb/clone.el.git")
    "git clone https://github.com/rodweb/clone.el.git")))

(ert-deftest test-clone-ssh ()
  "Should clone repository via SSH."
  (setq-local clone-function (lambda (command) command))
  (setq-local clone-protocol 'ssh)
  (should
   (equal
    (clone-repo "rodweb/clone.el")
    "git clone git@github.com:rodweb/clone.el.git"))
  (should
   (equal
    (clone-repo "git@github.com:rodweb/clone.el.git")
    "git clone git@github.com:rodweb/clone.el.git"))
  (should
   (equal
    (clone-repo "https://github.com/rodweb/clone.el.git")
    "git clone git@github.com:rodweb/clone.el.git")))

(ert-deftest test-clone-default-host ()
  "Should clone from default host."
  (setq-local clone-function (lambda (command) command))
  (setq-local clone-default-host "gitlab.com")
  (should
   (equal
    (clone-repo "rodweb/clone.el")
    "git clone https://gitlab.com/rodweb/clone.el.git"))
  (setq-local clone-protocol 'ssh)
  (should
   (equal
    (clone-repo "rodweb/clone.el")
    "git clone git@gitlab.com:rodweb/clone.el.git")))
