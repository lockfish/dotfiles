;;; packages.el --- DanielLayer layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2016 Sylvain Benner & Contributors
;;
;; Author: Tianhao Ren <locking@dyn-209-2-218-129.dyn.columbia.edu>
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
;; added to `DanielLayer-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `DanielLayer/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `DanielLayer/pre-init-PACKAGE' and/or
;;   `DanielLayer/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:

(defconst DanielLayer-packages
  '(
    evil
    )
  "The list of Lisp packages required by the DanielLayer layer.

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

(defun DanielLayer/post-init-evil ()
  ;; set up normal-state
  (define-key evil-normal-state-map "\C-k" 'evil-end-of-line)
  (define-key evil-normal-state-map "q" 'undo-tree-redo)
  ;; set up insert-state
  (define-key evil-insert-state-map "\C-l" [right]) ;; somehow evil-forward-char doesn't go beyond the ) in the end of line.
  ;; rebind :wq to just save and kill current buffer
  ;; Note on what is going on here
  ;; 1. originally tried (evil-write) (kill-this-buffer) but it doesn't work. evil-write takes some arguments.
  ;; 2. the following version copies the evil-save-and-close in evil-command.el, which makes use of the macro
  ;;    evil-define-command, defined in evil-common.
  ;; 3, the only difference is kill-this-buffer instead of the original evil-quit.
  (use-package evil-common
    :defer t
    :config
    (evil-define-command hooray/evil-write-and-quit-buffer ( file &optional bang )
      "Saves the current buffer and closes the current buffer."
      :repeat nil
      (interactive "<f><!>")
      (evil-write nil nil nil file bang)
      (kill-this-buffer)
      ))
  (use-package evil-ex
    :defer t ;; the evil package will load evil-ex, so it's deferred till then
    :config
    (evil-ex-define-cmd "wq" 'hooray/evil-write-and-quit-buffer)
    )
)
;;; packages.el ends here
