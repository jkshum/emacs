;(setq debug-on-error t)
(setenv "PATH" "/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/X11/bin:/opt/local/bin:/usr/local/git/bin:/usr/local/share/npm/bin")

(setq package-list  '(zenburn-theme
                      ace-jump-mode
                      multiple-cursors
                      company
                      jedi
		      yasnippet
                      js-comint
		      flycheck
		      paredit
		      cider
		      idomenu
		      company
                      ))

; list the repositories containing them

(setq package-archives '(("elpa" . "http://tromey.com/elpa/")
                         ("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")))
; activate all the packages (in particular autoloads)
(package-initialize)

;el-get
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
    (let (el-get-master-branch)
      (goto-char (point-max))
      (eval-print-last-sexp))))
(el-get 'sync)

(setq default-directory "~/Dropbox")
(menu-bar-mode -1) 
(tool-bar-mode -1) 
(scroll-bar-mode -1)

;key bindings
(setq mac-command-modifier 'meta) ; sets the Command key to Meta
(global-set-key (kbd "M-`") 'other-frame)
(global-set-key (kbd "C-h") 'backward-delete-char)
(global-set-key (kbd "C-?") help-map)
(global-set-key (kbd "M-h") 'backward-kill-word)
(global-set-key (kbd "C-M-n") 'down-list)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-c C->") 'set-rectangular-region-anchor)
(global-set-key (kbd "C-0") 'ace-jump-mode)
(global-set-key (kbd "C-x C-i") 'idomenu)
(windmove-default-keybindings)
(setq windmove-wrap-around t )

(add-hook 'emacs-lisp-mode-hook       #'paredit-mode)
(add-hook 'eval-expression-minibuffer-setup-hook #'paredit-mode)
(add-hook 'ielm-mode-hook             #'paredit-mode)
(add-hook 'lisp-mode-hook             #'paredit-mode)
(add-hook 'lisp-interaction-mode-hook #'paredit-mode)
(add-hook 'cider-mode-hook 'cider-turn-on-eldoc-mode)
(add-hook 'clojure-mode-hook 'paredit-mode)

;load theme fonts
(set-face-attribute 'default nil :height 140)
(load-theme 'zenburn)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;ido
(ido-mode 1)
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(autoload 'idomenu "idomenu" nil t)

;recent
(global-set-key (kbd "C-x C-r") 'ido-recentf-open)
(recentf-mode t)
(setq recentf-max-saved-items 50)
(defun ido-recentf-open ()
  "Use `ido-completing-read' to \\[find-file] a recent file"
  (interactive)
  (if (find-file (ido-completing-read "Find recent file: " recentf-list))
      (message "Opening file...")
    (message "Aborting")))

;auto save desktop session
(desktop-save-mode 1)

;python
;(add-hook 'python-mode-hook 'auto-complete-mode)
(add-hook 'python-mode-hook 'jedi:ac-setup)
(add-hook 'after-init-hook #'global-flycheck-mode)
(setq jedi:server-command '("~/.emacs.d/el-get/jedi/jediepcserver.py"))

;js repl
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(setq inferior-js-program-command "/usr/local/bin/node")
(setq inferior-js2-mode-hook
      (lambda ()
        ;; We like nice colors
        (ansi-color-for-comint-mode-on)
        ;; Deal wi
	th some prompt nonsense
        (add-to-list
         'comint-preoutput-filter-functions
         (lambda (output)
           (replace-regexp-in-string "\033\\[[0-9]+[GK]" "" output)))))

(add-hook 'js2-mode-hook '(lambda () 
			    (local-set-key "\C-x\C-e" 'js-send-last-sexp)
			    (local-set-key "\C-\M-x" 'js-send-last-sexp-and-go)
			    (local-set-key "\C-cb" 'js-send-buffer)
			    (local-set-key "\C-c\C-b" 'js-send-buffer-and-go)
			    (local-set-key "\C-c\C-l" 'js-load-file-and-go)
			    ))
(eval-after-load 'paredit
  '(progn
     (define-key paredit-mode-map (kbd "M-s") nil)))
(setenv "NODE_NO_READLINE" "1")

;(add-hook 'after-init-hook 'global-company-mode)

(yas-global-mode 1) ;; or M-x yas-reload-all if you've started YASnippet already.
(add-to-list 'ac-modes 'objc-mode)
;; --- Obj-C switch between header and source ---

(defun objc-in-header-file ()
  (let* ((filename (buffer-file-name))
         (extension (car (last (split-string filename "\\.")))))
    (string= "h" extension)))

(defun objc-jump-to-extension (extension)
  (let* ((filename (buffer-file-name))
         (file-components (append (butlast (split-string filename
                                                         "\\."))
                                  (list extension))))
    (find-file (mapconcat 'identity file-components "."))))

;;; Assumes that Header and Source file are in same directory
(defun objc-jump-between-header-source ()
  (interactive)
  (if (objc-in-header-file)
      (objc-jump-to-extension "m")

    (objc-jump-to-extension "h")))

(defun objc-mode-customizations ()
  (define-key objc-mode-map (kbd "C-c t") 'objc-jump-between-header-source))

(setq-default c-basic-offset 4)


(add-hook 'objc-mode-hook 'objc-mode-customizations)

(setq yas-snippet-dirs
      '("~/.emacs.d/el-get/yasnippet/snippets"))

(load (expand-file-name "~/quicklisp/slime-helper.el"))
(setq inferior-lisp-program "/usr/local/bin/sbcl")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("dd4db38519d2ad7eb9e2f30bc03fba61a7af49a185edfd44e020aa5345e3dca7" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(defun bp-add-objC-comment ()
  "Adds the /* -*- mode: objc -*- */ line at the top of the file"
  (interactive)
  (objc-mode)
  (let((p (point)))
    (goto-char 0)
    (insert "/* -*- mode: objc -*- */\n")
    (goto-char (+ p  (length "/* -*- mode: objc -*- */\n")))))
