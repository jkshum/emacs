;(setq debug-on-error t)
(setenv "PATH" "/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/X11/bin:/opt/local/bin:/usr/local/git/bin:/usr/local/share/npm/bin")
; list the packages you want
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
                      ))

; list the repositories containing them
(setq package-archives '(("elpa" . "http://tromey.com/elpa/")
                         ("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")))

; activate all the packages (in particular autoloads)
(package-initialize)

;bind to command 

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
(global-set-key (kbd "M-h") 'backward-kill-word)
(global-set-key (kbd "C-M-n") 'down-list)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-c C->") 'set-rectangular-region-anchor)

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

;ace jump
(define-key global-map (kbd "C-0") 'ace-jump-mode)

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
;(require 'desktop)
(desktop-save-mode 1)
(defun my-desktop-save ()
  (interactive)
  ;; Don't call desktop-save-in-desktop-dir, as it prints a message.
  (if (eq (desktop-owner) (emacs-pid))
      (desktop-save desktop-dirname)))
(add-hook 'auto-save-hook 'my-desktop-save)


;python
(add-hook 'python-mode-hook 'auto-complete-mode)
(add-hook 'python-mode-hook 'jedi:ac-setup)
(add-hook 'after-init-hook #'global-flycheck-mode)
(setq jedi:server-command '("~/.emacs.d/el-get/jedi/jediepcserver.py"))

;js repl
(setq inferior-js-program-command "/usr/local/bin/node")
(setq inferior-js-mode-hook
      (lambda ()
        ;; We like nice colors
        (ansi-color-for-comint-mode-on)
        ;; Deal with some prompt nonsense
        (add-to-list
         'comint-preoutput-filter-functions
         (lambda (output)
           (replace-regexp-in-string "\033\\[[0-9]+[GK]" "" output)))))

(add-hook 'js-mode-hook '(lambda () 
			    (local-set-key "\C-x\C-e" 'js-send-last-sexp)
			    (local-set-key "\C-\M-x" 'js-send-last-sexp-and-go)
			    (local-set-key "\C-cb" 'js-send-buffer)
			    (local-set-key "\C-c\C-b" 'js-send-buffer-and-go)
			    (local-set-key "\C-cl" 'js-load-file-and-go)
			    ))
(eval-after-load 'paredit
  '(progn
     (define-key paredit-mode-map (kbd "M-s") nil)))

(add-hook 'after-init-hook 'global-company-mode)

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
