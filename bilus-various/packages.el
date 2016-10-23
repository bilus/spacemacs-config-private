(setq bilus-various-packages
      '(
      ;; ag
      ;; rainbow-delimiters

      ;; idle-highlight-mode
        ;; makes handling lisp expressions much, much easier
        ;; Cheatsheet: http://www.emacswiki.org/emacs/PareditCheatsheet
        ;; paredit
        ;; Semantic region expansion
        ;; expand-region
        ;; flycheck-clojure
        ;; flycheck-pos-tip
        ;; symbol search
        ;; smartscan
        ;; Searching
        ;; swiper
        ;; Dash API reference integration
        ;; helm-dash
        ;; Plant UML
        ;;puml-mode
        ;; plantuml-mode
        feature-mode

        yaml-mode
        ;; flymake-yaml
        ))

;; (defun bilus-various/init-ag ()
;;   (use-package ag))

;; (defun bilus-various/init-idle-rainbow-delimiters ()
;;   (use-package idle-rainbow-delimiters))

;; (defun bilus-various/init-idle-highlight-mode ()
;;   (use-package idle-highlight-mode))

;; (defun bilus-various/init-paredit ()
;;   (use-package paredit))

;; (defun bilus-various/init-expand-region
;; ()
;;   (use-package expand-region))

;; ;;(defun bilus-various/init-flycheck-pos-tip ())
;; (defun bilus-various/init-smartscan ()
;;   (use-package smartscan))

;; (defun bilus-various/init-swiper ()
;;   (use-package swiper))

;; (defun bilus-various/init-helm-dash ()
;;   (use-package helm-dash
;;     :init 'helm-dash-install-docset))

;; (defun bilus-various/init-puml-mode ()
;;   (use-package puml-mode
;;     ;;:init (setq puml-plantuml-jar-path "~/.emacs.d/layers/bilus-various/plantuml.jar")
;;     )
;;   )

;; (setq org-plantuml-jar-path
;;       (expand-file-name "~/.emacs.d/layers/bilus-various/plantuml.jar"))

;; (defun bilus-various/init-plantuml-mode ()
;;   (use-package plantuml-mode))

(defun bilus-various/init-feature-mode ()
  (use-package feature-mode
    :init '(progn
            (setq feature-default-language "fi")
            (add-to-list 'auto-mode-alist '("\.feature$" . feature-mode))
    )))
