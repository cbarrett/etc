;; -*- mode: emacs-lisp -*-

;; Please, spacemacs, you're my only hope!
;; XXXcb does this need to be *here*?
(load (expand-file-name "template.el" dotspacemacs-directory))

(defun dotspacemacs/layers ()
  "Configuration Layers declaration.
You should not put any user code in this function besides modifying the variable
values."
  (dotspacemacs-template/layers)
  (setq-default
   dotspacemacs-configuration-layers
   `(swift
     auto-completion
     syntax-checking
     ivy
     osx
     nixos
     python
     emacs-lisp
     html
     agda
     )
   dotspacemacs-excluded-packages
   '(
     ;; https://github.com/syl20bnr/spacemacs/issues/8537#issuecomment-307056392
     exec-path-from-shell
     ;; https://github.com/syl20bnr/spacemacs/issues/9374#issuecomment-325238803
     ;; org-projectile
     )
   ))

(defun dotspacemacs/init ()
  "Initialization function.
This function is called at the very startup of Spacemacs initialization
before layers configuration.
You should not put any user code in there besides modifying the variable
values."
  (dotspacemacs-template/init)
  (setq-default
   dotspacemacs-line-numbers 'relative
   dotspacemacs-persistent-server t
   dotspacemacs-whitespace-cleanup 'changed
   dotspacemacs-search-tools '("rg" "grep")
   dotspacemacs-themes
   '(birds-of-paradise-plus
     sanityinc-tomorrow-blue
     django
     sanityinc-solarized-dark
     sanityinc-solarized-light
     spacemacs-dark
     spacemacs-light)
   dotspacemacs-default-font
   '("Base Mono Narrow OT"
     :size 14
     :weight ultralight
     :powerline-scale 1.2)
   ))

(defun dotspacemacs/user-init ()
  "Initialization function for user code.
It is called immediately after `dotspacemacs/init', before layer configuration
executes.
 This function is mostly useful for variables that need to be set
before packages are loaded. If you are unsure, you should try in setting them in
`dotspacemacs/user-config' first."
  (setq-default
   ;; Tell emacs to take its crap and shove it here
   custom-file (expand-file-name "custom.el" dotspacemacs-directory)
   ))

(defun dotspacemacs/user-config ()
  "Configuration function for user code.
This function is called at the very end of Spacemacs initialization after
layers configuration.
This is the place where most of your configurations should be done. Unless it is
explicitly specified that a variable should be set before a package is loaded,
you should place your code here."
  ;; Tell emacs we'd very much like some crap now
  (load custom-file))
