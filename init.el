;(setq debug-on-error t)
(setenv "PATH" "/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/X11/bin:/opt/local/bin:/usr/local/git/bin:/usr/local/share/npm/bin:~/android-sdk/tools:~/android-sdk/platform-tools")
(setq exec-path (append exec-path '("/usr/local/bin" "/opt/local/bin")))

(setq package-list  '(zenburn-theme
                      ace-jump-mode
                      multiple-cursors
                      company
		      js2-mode
                      jedi
		      yasnippet
                      js-comint
		      flycheck
		      paredit
		      cider
		      idomenu
		      company
		      elm-mode
		      rainbow-mode
		      skewer-mode
                      ))

; list the repositories containing them

(setq package-archives '(("melpa" . "http://melpa.milkbox.net/packages/")
			 ("ELPA" . "http://elpa.gnu.org/packages")
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

(setq default-directory "~/")
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
(global-set-key (kbd "C-M-p") 'backward-up-list)
(global-set-key (kbd "M-p") 'mc/mark-previous-like-this)
(global-set-key (kbd "M-n") 'mc/mark-next-like-this)
(global-set-key (kbd "C-c M-r") 'set-rectangular-region-anchor)
(global-set-key (kbd "C-0") 'ace-jump-mode)
(global-set-key (kbd "C-x C-i") 'idomenu)


(setq windmove-wrap-around t)
(global-set-key (kbd "C-c <left>")  'windmove-left)
(global-set-key (kbd "C-c <right>") 'windmove-right)
(global-set-key (kbd "C-c <up>")    'windmove-up)
(global-set-key (kbd "C-c <down>")  'windmove-down)

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
(set-frame-font "Monaco 14")

;ido
(ido-mode 1)
(setq ido-enablle-flex-matching t)
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
(global-auto-complete-mode t)

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
			    (tern-mode t)
 			    (local-set-key "\C-x\C-e" 'js-send-last-sexp)
			    (local-set-key "\C-\M-x" 'js-send-last-sexp-and-go)
			    (local-set-key "\C-cb" 'js-send-buffer)
			    (local-set-key "\C-c\C-b" 'js-send-buffer-and-go)
			    (local-set-key "\C-c\C-l" 'js-load-file-and-go)
			    ))
(eval-after-load 'tern
   '(progn
      (require 'tern-auto-complete)
      (tern-ac-setup)))

(add-hook 'js2-mode-hook 'skewer-mode)
(add-hook 'css-mode-hook 'skewer-css-mode)
(add-hook 'html-mode-hook 'skewer-html-mode)
(add-hook 'css-mode-hook 'rainbow-mode)

(eval-after-load 'paredit
  '(progn
     (define-key paredit-mode-map (kbd "M-s") nil)))
(setenv "NODE_NO_READLINE" "1")

(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t))) 

;(add-hook 'after-init-hook 'global-company-mode)

(yas-global-mode 1) ;; or M-x yas-reload-all if you've started YASnippet already.

;; --- Obj-C switch between header and source ---

(setq yas-snippet-dirs
      '("~/.emacs.d/el-get/yasnippet/snippets"))

(load (expand-file-name "~/quicklisp/slime-helper.el"))
(setq inferior-lisp-program "/usr/local/bin/sbcl")

(defun beautify-json ()
  (interactive)
  (let ((b (if mark-active (min (point) (mark)) (point-min)))
        (e (if mark-active (max (point) (mark)) (point-max))))
    (shell-command-on-region b e
     "python -mjson.tool" (current-buffer) t)))
