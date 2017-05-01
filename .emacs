; let me use common lisp functions
(require 'cl)

;; keys

(global-set-key [f1] 'other-window)
(global-set-key [f2] 'start-new-eshell)
(global-set-key [f3] 'start-kbd-macro)
(global-set-key [f4] 'end-kbd-macro)
(global-set-key [f5] 'apply-macro-to-region-lines)

;; copy line to the kill ring with F8
(global-set-key [f8] 'copy-line-as-kill)

(setq hippie-expand-try-functions-list
      '(try-expand-dabbrev
	try-expand-dabbrev-all-buffers
	try-expand-dabbrev-from-kill
	try-expand-whole-kill
	try-complete-file-name-partially
	try-complete-file-name))

(global-set-key [f9] '(lambda () (interactive)
			(if (fboundp 'recompile) (recompile) (call-interactively 'compile))))
(global-set-key [f10] 'next-error)

(global-set-key (kbd "M-<SPC>") 'hippie-expand)

;; graphics

; file name : complete path 
(setq frame-title-format "%b : %f")

(setq inhibit-startup-message t)

(tool-bar-mode -1)

; yank at point, not where the mouse pointer is
(setq mouse-yank-at-point t)

(require 'windmove)
; S-<arrow key> moves to the pointed window
(windmove-default-keybindings)
; wrap around to opposite side if at edge
(setq windmove-wrap-around t)

;; defaults

(prefer-coding-system 'utf-8)
(set-language-environment 'utf-8)

(column-number-mode t)

; highlight maching parens
(show-paren-mode t)

(setq which-func-modes t)
(which-func-mode t)

;; programming

(defun multi-add-hook (modes hook)
  (mapcar '(lambda (mode) (add-hook mode hook)) modes))

; c/c++
; linux style for all but java
(setq c-default-style
   '((java-mode . "java") (other . "linux")))
; one tab = 2 whitespaces
(setq c-basic-offset 2)
; add an offset for public, protected and private (C++)
(c-set-offset 'access-label '-)
(c-set-offset 'inclass '+)

; emacs lisp
; add the lisp symbols for the smart completion
(multi-add-hook '(emacs-lisp-mode-hook ielm-mode-hook)
		'(lambda ()
		   (make-local-variable 'hippie-expand-try-functions-list)
		   (setq hippie-expand-try-functions-list
			 (append hippie-expand-try-functions-list
				 '(try-complete-lisp-symbol-partially
				   try-complete-lisp-symbol)))))

;; eshell

(require 'eshell)

(defun start-new-eshell ()
  (interactive)
  (let ((buf eshell-buffer-name)
	(num 1))
    (while (get-buffer buf)
      (setq buf (format "%s<%d>" eshell-buffer-name (incf num))))
    (eshell (if (/= num 1) num nil))))

(defun eshell/ffow (file)
  (find-file-other-window file))
(defun eshell/ffof (file)
  (find-file-other-frame file))

;; custom functions

(defun copy-line-as-kill ()
  "Copy the current line to the kill ring."
  (interactive)
  (save-excursion
    (end-of-line)
    (let ((endpos (point)))
      (beginning-of-line)
      (copy-region-as-kill (point) endpos))))
