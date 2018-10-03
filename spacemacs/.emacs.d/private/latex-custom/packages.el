;;; packages.el --- latex-custom layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2016 Sylvain Benner & Contributors
;;
;; Author: Tianhao Ren <locking@dyn-209-2-218-253.dyn.columbia.edu>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;;; Commentary:

;; See the Spacemacs documentation and FAQs for instructions on how to implement
;; a new layer:

;;   SPC h SPC layers RET
;;
;;
;; Briefly, each package to be installed or configured by this layer should be
;; added to `latex-custom-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `latex-custom/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `latex-custom/pre-init-PACKAGE' and/or
;;   `latex-custom/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:

;; (defconst latex-custom-packages
;;   '()
;;   "The list of Lisp packages required by the latex-custom layer.

;; Each entry is either:

;; 1. A symbol, which is interpreted as a package to be installed, or

;; 2. A list of the form (PACKAGE KEYS...), where PACKAGE is the
;;     name of the package to be installed or loaded, and KEYS are
;;     any number of keyword-value-pairs.

;;     The following keys are accepted:

;;     - :excluded (t or nil): Prevent the package from being loaded
;;       if value is non-nil

;;     - :location: Specify a custom installation location.
;;       The following values are legal:

;;       - The symbol `elpa' (default) means PACKAGE will be
;;         installed using the Emacs package manager.

;;       - The symbol `local' directs Spacemacs to load the file at
;;         `./local/PACKAGE/PACKAGE.el'

;;       - A list beginning with the symbol `recipe' is a melpa
;;         recipe.  See: https://github.com/milkypostman/melpa#recipe-format")


(defconst latex-custom-packages
  '(
    auctex
    (cdlatex :location elpa)
    pdf-tools
    ;; yasnippet
    ))

(defun latex-custom/post-init-auctex ()
    ;; ; turn on TeX-source-correlate-mode automatically
    ;; (add-hook 'LaTeX-mode-hook 'TeX-source-correlate-mode)
    ; turn on interactive
    (add-hook 'LaTeX-mode-hook 'TeX-interactive-mode)
    ; turn on auto-fill-mode
    ;; (add-hook 'LaTeX-mode-hook 'auto-fill-mode)
    ;; Highlight TIP in latex mode
    (add-hook 'LaTeX-mode-hook
              (lambda ()
                (font-lock-add-keywords nil
                                        '(("\\<\\(TIP\\):" 1 font-lock-warning-face t)))
                ))
    ;; (add-hook 'LaTeX-mode-hook 'turn-on-reftex) ;; reftex is needed for cdlatex labels to work
    (add-hook 'LaTeX-mode-hook 'flyspell-mode)   ; with AUCTeX LaTeX mode
    ;; (add-hook 'latex-mode-hook 'flyspell-mode)   ; with Emacs latex mode
    ;; Set the minimum number of characters for completion to be 4
    ;; TIP: config works like eval-after-load, so for buffer-local settings, one should use mode hook
    (add-hook 'LaTeX-mode-hook '(lambda ()
                                  (setq-local company-minimum-prefix-length 4)))
    ;; (add-hook 'reftex-mode-hook '(lambda ()
    ;;                                (define-key reftex-mode-map "j" 'reftex-toc-previous)
    ;;                                (define-key reftex-mode-map "k" 'reftex-toc-next)
    ;;                                ;; k was originally bound to reftex-toc-quit-and-kill, so rebind it 
    ;;                                (define-key reftex-mode-map "n" 'reftex-toc-quit-and-kill)
    ;;                                ;; the following keys will be unset
    ;;                                (define-key reftex-mode-map "C-n" nil)
    ;;                                (define-key reftex-mode-map "C-p" nil)
    ;;                                ))

    (defun setup-synctex-latex ()
      (setq TeX-source-correlate-method (quote synctex))
      (setq TeX-source-correlate-mode t)
      (setq TeX-source-correlate-start-server t)
      ;; (setq TeX-view-program-list
      ;;       (quote
      ;;        (("Okular" "okular --unique \"%o#src:%n$(pwd)/./%b\""))))
      (setq TeX-view-program-selection
            (quote
             (((output-dvi style-pstricks)
               "dvips and gv")
              (output-dvi "xdvi")
              (output-pdf "PDF Tools")
              (output-html "xdg-open")))))


    (add-hook 'LaTeX-mode-hook 'setup-synctex-latex)
    ;; the latexmk option -pvc makes latexmk automatically update pdf whenever changes are made to source file.
    (add-hook 'LaTeX-mode-hook (lambda () (add-to-list 'TeX-command-list '("MkLaTeX" "latexmk -pdf -pdflatex='pdflatex -file-line-error -synctex=1' -pvc %t" TeX-run-command nil (latex-mode docTeX-mode)))))
    (add-hook 'LaTeX-mode-hook (lambda () (setq TeX-command-default "MkLaTeX")))
    (add-hook 'LaTeX-mode-hook (lambda () (define-key LaTeX-mode-map (kbd "<double-mouse-1>") 'pdf-sync-forward-search)))

  (spacemacs|use-package-add-hook tex
    :post-config
    (setq TeX-auto-save t)
    (setq TeX-parse-self t)
    (setq TeX-show-compilation nil)
    ;; (setq-default TeX-master nil)
    ;; (add-hook 'reftex-load-hook '(lambda ()
    ;;                                (define-key reftex-mode-map "k" 'reftex-toc-previous)
    ;;                                (define-key reftex-mode-map "j" 'reftex-toc-next)
    ;;                                ;; k was originally bound to reftex-toc-quit-and-kill, so rebind it 
    ;;                                (define-key reftex-mode-map "n" 'reftex-toc-quit-and-kill)
    ;;                                ;; the following keys will be unset
    ;;                                (define-key reftex-mode-map "C-n" nil)
    ;;                                (define-key reftex-mode-map "C-p" nil)
    ;;                                ))
    )
  )


(defun latex-custom/init-cdlatex ()
  (use-package cdlatex
    :load-path "private/cdlatex"
    :commands turn-on-cdlatex
    :init
    (add-hook 'LaTeX-mode-hook 'turn-on-cdlatex)   ; with AUCTeX LaTeX mode
    (add-hook 'latex-mode-hook 'turn-on-cdlatex)   ; with Emacs latex mode
    ;; set the defcustom variables. Note that these two variables must be set
    ;; before package loading, in which, for example, cdlatex-math-symbol-prefix
    ;; will be used to bind key to function cdlatex-math-symbol. Setting this
    ;; variable after this step is useless.
    (custom-set-variables
     '(cdlatex-math-symbol-prefix ?\;)
     ;; '(cdlatex-math-modify-prefix ?')
     )
    :config
    ;; first try expanding yasnippet, then cdlatex-tab
    ;; FIXME when yasnippet is expanded, the tab is bound to yas-next-field-or-maybe-expand
    ;; does this have to do with mode-map order?
    ;; seems that the key bindings for yas-keymap are not run, why?
    (defun smart-tab ()
      (interactive)
      (let ((yas-fallback-behavior 'return-nil))
        (if (null (yas-expand))
            (cdlatex-tab)
          )))
    (define-key cdlatex-mode-map "\t" 'smart-tab)
    ;; use evil-define-key to rebind some keys in insert state
    (evil-define-key 'insert LaTeX-mode-map (kbd "M-u") (kbd "^") ) 
    (evil-define-key 'insert LaTeX-mode-map (kbd "M-;")
      '(lambda ()
         (interactive)
         (insert ?\;)) )
    ;; customize some symbols
    (custom-set-variables
     '(cdlatex-paired-parens "$([{") ;; add ( in auto pairing
     '(cdlatex-env-alist
       '(
         ;;------------------------------------
         ( "array"
           "\\begin{array}[tb]{?lcrp{width}*{num}{lcrp{}}|}
     & & & 
\\end{array}"
           "\\\\     ?& & &"
           )
         ;;------------------------------------
         ( "eqnarray"
           "\\begin{eqnarray}
AUTOLABEL
    ? &  & 
\\end{eqnarray}"
           "\\\\    AUTOLABEL
    ? &  & "
           )
         ;;------------------------------------
         ( "eqnarray*"
           "\\begin{eqnarray*}
    ? &  & 
\\end{eqnarray*}"
           "\\\\    ? &  & "
           )
         ;;------------------------------------

         ))
     '(cdlatex-command-alist
       '(
         ("int"       "Insert \\int_{}^{}"
          "\\int_{?}^{}"  cdlatex-position-cursor nil nil t)
         ("nn"        "nonumber followed by a new item"
          "\\nonumber" cdlatex-item nil t t)
         ))
     '(cdlatex-math-symbol-alist
       '(
         ( ?F  ("\\Phi"                 ))
         ( ?n  ("\\nu"             "\\nabla"                "\\ln"))
         ))
     '(cdlatex-math-modify-alist
       '(
         ( ?b    "\\boldsymbol"            "\\textbf" t   nil nil )
         ))
     )
    ))

(defun latex-custom/init-pdf-tools ()
  (setenv "PKG_CONFIG_PATH"
     "/usr/local/Cellar/zlib/1.2.8/lib/pkgconfig:/usr/local/lib/pkgconfig:/opt/X11/lib/pkgconfig"
                )
  (pdf-tools-install)

  (add-hook 'LaTeX-mode-hook '(lambda ()
                                (unless (assoc "PDF Tools" TeX-view-program-list-builtin)
                                  (push '("PDF Tools" TeX-pdf-tools-sync-view) TeX-view-program-list))))
  )

;; (defun latex-custom/post-init-yasnippet()
;;  (setq yas-snippet-dirs
;;        '("~/.emacs.d/private/snippets")
;;        )
;;  (yas-global-mode 1);; or M-x yas-reload-all if you've started YASnippet already.
;;  (setq yas-indent-line 'fixed)
;;  ;;(setq yas-also-auto-indent-first-line t)
;;  ;; continued from post-init-company
;;  ;; (define-key yas-minor-mode-map [tab] nil)
;;  (define-key yas-minor-mode-map (kbd "TAB") nil)

;;  ;; ;; (define-key yas-keymap [tab] 'tab-complete-or-next-field)
;;  ;; (define-key yas-keymap (kbd "TAB") 'tab-complete-or-next-field)
;;  ;; (define-key yas-keymap [(control tab)] 'yas-next-field)
;;  ;; (define-key yas-keymap (kbd "C-g") 'abort-company-or-yas)
;;  ;; ;; ;; end of conflict solver
;;  )

;;; packages.el ends here
