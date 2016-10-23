(global-set-key (kbd "C--") 'er/expand-region)
(global-set-key (kbd "C-_") 'er/contract-region)

(define-key global-map (kbd "RET") 'newline-and-indent)

;; Handle Polish chars.
(setq ns-right-alternate-modifier nil)

;; Save all buffers on lost focus.
(add-hook 'focus-out-hook (lambda () (save-some-buffers t)))

;; Always reload changed files.
(global-auto-revert-mode 1)

;; Treat selection in a more standard way (e.g. typing kills it) even in paredit.
(delete-selection-mode 1)
(put 'paredit-forward-delete 'delete-selection 'supersede)
(put 'paredit-backward-delete 'delete-selection 'supersede)
(put 'paredit-newline 'delete-selection t)

;; Turn off line wrapping.
(set-default 'truncate-lines t)
(setq truncate-partial-width-windows nil)

;; Autocomplete.
(add-hook 'after-init-hook 'global-company-mode)
(global-set-key (kbd "TAB") #'company-indent-or-complete-common) ;; Use TAB for indenting AND for autocompletion.

;; Searching using Swiper+Ivy.
;; (autoload 'ivy-read "ivy")
;; (ivy-mode 1)
;;(setq ivy-use-virtual-buffers t)
(global-set-key "\C-s" 'swiper)
(global-set-key "\C-r" 'swiper)
;;(global-set-key (kbd "C-c C-r") 'ivy-resume)
;;(global-set-key [f6] 'ivy-resume)

;; Go back to previous buffer.
(defun switch-to-previous-buffer ()
  "Switch to previously open buffer.
Repeated invocations toggle between the two most recently open buffers."
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) 1)))
(global-set-key (kbd "C-c b") 'switch-to-previous-buffer)

(defun setup-progmode ()
  ;; Highlight word usages.
  (idle-highlight-mode t)
  ;; Symbol search
  (smartscan-mode 1))

;;(add-hook 'prog-mode-hook 'setup-progmode)

;; Ag results.
(setq ag-highlight-search t)
(setq ag-reuse-window 't)
(setq ag-reuse-buffers 't)

;; Flycheck
(add-hook 'after-init-hook #'global-flycheck-mode)
;;(with-eval-after-load 'flycheck
;;   (flycheck-pos-tip-mode))

;; Mark lines with TODO:

(defun annotate-todo ()
  "put fringe marker on TODO: lines in the curent buffer"
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward "TODO:" nil t)
      (let ((overlay (make-overlay (- (point) 5) (point))))
        (overlay-put overlay 'before-string (propertize "A"
                                                        'display '(left-fringe right-triangle)))))))
(add-hook 'find-file-hooks 'annotate-todo)

;; Switch between buffers
(global-set-key (read-kbd-macro "<C-tab>") 'other-window)

;; comments
(defun toggle-comment-on-line ()
  "comment or uncomment current line"
  (interactive)
  (comment-or-uncomment-region (line-beginning-position) (line-end-position)))
(global-set-key (kbd "C-;") 'toggle-comment-on-line)

;; Duplicate current line or region
(defun duplicate-current-line-or-region (arg)
  "Duplicates the current line or region ARG times.
If there's no region, the current line will be duplicated. However, if
there's a region, all lines that region covers will be duplicated."
  (interactive "p")
  (let (beg end (origin (point)))
    (if (and mark-active (> (point) (mark)))
        (exchange-point-and-mark))
    (setq beg (line-beginning-position))
    (if mark-active
        (exchange-point-and-mark))
    (setq end (line-end-position))
    (let ((region (buffer-substring-no-properties beg end)))
      (dotimes (i arg)
        (goto-char end)
        (newline)
        (insert region)
        (setq end (point)))
      (goto-char (+ origin (* (length region) arg) arg)))))

(global-set-key (kbd "C-c d") 'duplicate-current-line-or-region)

;; IDO-related

;; ido-mode allows you to more easily navigate choices. For example,
;; when you want to switch buffers, ido presents you with a list
;; of buffers in the the mini-buffer. As you start to type a buffer's
;; name, ido will narrow down the list of buffers to match the text
;; you've typed in
;; http://www.emacswiki.org/emacs/InteractivelyDoThings
(ido-mode t)

;; This allows partial matches, e.g. "tl" will match "Tyrion Lannister"
(setq ido-enable-flex-matching t)

;; Turn this behavior off because it's annoying
(setq ido-use-filename-at-point nil)

;; Don't try to match file across all "work" directories; only match files
;; in the current directory displayed in the minibuffer
(setq ido-auto-merge-work-directories-length -1)

;; Includes buffer names of recently open files, even if they're not
;; open now
(setq ido-use-virtual-buffers t)

;; This enables ido in all contexts where it could be useful, not just
;; for selecting buffer and file names
;; (ido-ubiquitous-mode 1)

;; Shows a list of buffers
(global-set-key (kbd "C-x C-b") 'ibuffer)

;;(global-set-key (kbd "M-right") 'forward-word)

(global-set-key (kbd "M-s-f") 'iedit-mode)

;; Remove trailing whitespace on save
(add-hook 'before-save-hook 'delete-trailing-whitespace)

(spacemacs|diminish rubocop-mode " 🤖" " R")

(add-hook 'lisp-mode-hook #'enable-paredit-mode)
(add-hook 'clojure-mode-hook #'enable-paredit-mode)



;; Customized filter: don't mark *all* identifiers
(defun amitp/rainbow-identifiers-filter (beg end)
  "Only highlight standalone words or those following 'this.' or 'self.'"
  (let ((curr-char (char-after beg))
        (prev-char (char-before beg))
        (prev-self (buffer-substring-no-properties
                    (max (point-min) (- beg 5)) beg)))
    (and (not (member curr-char
                    '(?0 ?1 ?2 ?3 ?4 ?5 ?6 ?7 ?8 ?9 ??)))
         (or (not (equal prev-char ?\.))
             (equal prev-self "self.")
             (equal prev-self "this.")))))

;; Filter: don't mark identifiers inside comments or strings
(setq rainbow-identifiers-faces-to-override
      '(font-lock-type-face
        font-lock-variable-name-face
        font-lock-function-name-face))

;; Set the filter
(add-hook 'rainbow-identifiers-filter-functions 'amitp/rainbow-identifiers-filter)

;; Use a wider set of colors
(setq rainbow-identifiers-choose-face-function
      'rainbow-identifiers-cie-l*a*b*-choose-face)
(setq rainbow-identifiers-cie-l*a*b*-lightness 45)
(setq rainbow-identifiers-cie-l*a*b*-saturation 45)

(setq vi-tilde-fringe-mode nil)

;; Presentations

(eval-after-load "org-present"
  '(progn
     (add-hook 'org-present-mode-hook
               (lambda ()
                 (org-present-big)
                 (org-display-inline-images)
                 (org-present-hide-cursor)
                 (org-present-read-only)))
     (add-hook 'org-present-mode-quit-hook
               (lambda ()
                 (org-present-small)
                 (org-remove-inline-images)
                 (org-present-show-cursor)
                 (org-present-read-write)))))

;; Show clock

(defface egoge-display-time
  '((((type x w32 mac))
     ;; #060525 is the background colour of my default face.
     (:foreground "white" :inherit bold))
    (((type tty))
     (:foreground "blue")))
  "Face used to display the time in the mode line.")
;; This causes the current time in the mode line to be displayed in
;; `egoge-display-time-face' to make it stand out visually.
(setq display-time-string-forms
      '((propertize (concat " " 24-hours ":" minutes " ")
                    'face 'egoge-display-time)))

(display-time-mode 1)

;; Pomodoro

(setq org-pomodoro-ticking-sound-p t)
(setq org-pomodoro-keep-killed-pomodoro-time t)
(setq org-pomodoro-ticking-sound "/Users/martinb/.emacs.d/layers/bilus-various/tick.wav")
(setq org-pomodoro-ticking-sound-states '(:pomodoro))

;; Plant UML

(add-to-list 'auto-mode-alist '("\\.puml\\'" . plantuml-mode))

(setq org-time-clocksum-use-fractional t)

;; org-reveal
;; http://matt.hackinghistory.ca/2015/07/11/creating-and-publishing-presentations-with-org-reveal/
;(add-to-list 'load-path "~/.emacs.d/layers/bilus-various/src/org-reveal")
;(require 'ox-reveal)
;; set local root
;;(setq org-reveal-root "http://cdn.bootcss.com/reveal.js/3.0.0/js/reveal.js")
;(setq org-reveal-title-slide nil)

(setq org-todo-keyword-faces
      '(("TODO" . org-todo)
        ("DONE" .org-done)
        ("API" . "yellow")
        ("LATER" . "red")
        ("CUCUMBER" . "orange" )
        ))

;; Figwheel with cider.
;; http://cider.readthedocs.io/en/latest/up_and_running/#using-the-figwheel-repl-leiningen-only
(setq cider-cljs-lein-repl "(do (use 'figwheel-sidecar.repl-api) (start-figwheel!) (cljs-repl))")

;; RSI
(define-key key-translation-map (kbd "M-SPC") (kbd "_"))

;; active Org-babel languages
;; (org-babel-do-load-languages
;;  'org-babel-load-languages
;;  '(;; other Babel languages
;;    (plantuml . t)))
