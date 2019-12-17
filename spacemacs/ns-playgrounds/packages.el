;;; packages.el --- ns-playgrounds layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2018 Sylvain Benner & Contributors
;;
;; Author: Colin Barrett <cbarrett@Lexx.local>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;;; Commentary:

;; See the Spacemacs documentation and FAQs for instructions on how to implement
;; a new layer:
;;
;;   SPC h SPC layers RET
;;
;;
;; Briefly, each package to be installed or configured by this layer should be
;; added to `ns-playgrounds-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `ns-playgrounds/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `ns-playgrounds/pre-init-PACKAGE' and/or
;;   `ns-playgrounds/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:

(defconst ns-playgrounds-packages
  '((ns-playgrounds :location (recipe
                               :fetcher github
                               :repo "danielmartin/ns-playgrounds")))
  "The list of Lisp packages required by the ns-playgrounds layer.

Each entry is either:

1. A symbol, which is interpreted as a package to be installed, or

2. A list of the form (PACKAGE KEYS...), where PACKAGE is the
    name of the package to be installed or loaded, and KEYS are
    any number of keyword-value-pairs.

    The following keys are accepted:

    - :excluded (t or nil): Prevent the package from being loaded
      if value is non-nil

    - :location: Specify a custom installation location.
      The following values are legal:

      - The symbol `elpa' (default) means PACKAGE will be
        installed using the Emacs package manager.

      - The symbol `local' directs Spacemacs to load the file at
        `./local/PACKAGE/PACKAGE.el'

      - A list beginning with the symbol `recipe' is a melpa
        recipe.  See: https://github.com/milkypostman/melpa#recipe-format")

(defun ns-playgrounds/init-ns-playgrounds ()
  (use-package ns-playgrounds)
  )
(defun ns-playgrounds/post-init-ns-playgrounds ()
  (setq ob-swift-toolchain-dirs '("~/Library/Developer/Toolchains/"))
  (defun ob-swift--toolchain-eval (body &optional toolchain)
    "Evaluate BODY using optionally a Swift TOOLCHAIN"
    (org-babel-eval (format "%s run --repl" (ob-swift--toolchain-path toolchain)) body)
    )
  (defun ob-swift--prepare-session (session &optional toolchain)
    "Prepare a REPL SESSION where Swift source blocks can be executed."
    (let ((name (format "*ob-swift-%s*" session)))
      (unless (and (get-process name)
                   (process-live-p (get-process name)))
        (let* ((swift-command-line (append (split-string
                                            (ob-swift--toolchain-path toolchain))
                                           '("run" "--repl")))
               (process (with-current-buffer (get-buffer-create
                                              name)
                          (apply 'start-process name name
                                 (car swift-command-line)
                                 (cdr swift-command-line)))))
          (set-process-filter process 'ob-swift--process-filter)
          (ob-swift--wait "Welcome to Apple Swift"))))
    )
  )
;;; packages.el ends here
