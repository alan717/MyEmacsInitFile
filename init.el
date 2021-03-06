;;; package --- sumary
;;; Commentary:
;;; Code:
;;; 我的配置2020/02/20

(defvar inhibit-startup-message t)
;;
(require 'package)
;;;此项nil时候不会自动加载所有package
(setq package-enable-at-startup nil)
(show-paren-mode 1)
;;(add-to-list 'package-archives
 ;;           '("melpa" . "http://melpa.org/packages/"))
(setq package-archives '(("gnu" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                         ("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))


;;(setq url-proxy-services '(("no_proxy" . "baidu.com")
  ;;                         ("http" . "127.0.0.1:8118")))
(add-to-list 'load-path "~/.emacs.d/my/ndk4emacs-20200223001/")
(add-to-list 'load-path "~/play/org-page/")
;;
;;;(require 'smex)
;;(require 'flycheck-rtags)
(package-initialize)

(when (not package-archive-contents)
    (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
;;(require 'ndk4emacs)
;;(setq use-package-always-ensure t)
;;错误时候打开回溯栈
;;
(setq debug-on-error t)



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("732b807b0543855541743429c9979ebfb363e27ec91e82f463c91e68c772f6e3" "a24c5b3c12d147da6cef80938dca1223b7c7f70f2f382b26308eba014dc4833a" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "a8245b7cc985a0610d71f9852e9f2767ad1b852c2bdea6f4aadc12cce9c4d6d0" "e61752b5a3af12be08e99d076aedadd76052137560b7e684a8be2f8d2958edc3" "13d20048c12826c7ea636fbe513d6f24c0d43709a761052adbca052708798ce3" "26d49386a2036df7ccbe802a06a759031e4455f07bda559dcf221f53e8850e69" default)))
 '(package-selected-packages
   (quote
    (company dracula-theme counsel-projectile yasnippet avy counsel ivy subr-x window-numbering company-rtags flycheck-rtags moe-theme nyan-mode solarized-theme org-mode projectile cmake-mode irony company-irony flycheck-irony irony-eldoc use-package undo-tree counsel-projectile anzu req-package flycheck  mime-view dired ecb2 material-theme elpy blacken ht))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(package-install-selected-packages)
(require 'req-package)
;; config req-package
(setq req-package-log-level 'debug)

(req-package ndk4emacs
  )
;; config windows-numbering
(req-package window-numbering
  :config
  (progn
    (add-hook 'after-init-hook 'window-numbering-mode)
    ))


;; (req-package company
;;  :config
;;   (progn
;;     (add-hook 'after-init-hook 'global-company-mode)
;;     (global-set-key (kbd "M-/") 'company-complete-common-or-cycle)
;;     (setq company-idle-delay 0)
;;     ))


(req-package flycheck
  :config
  (progn
    (global-flycheck-mode))
  )

;; (req-package irony
;;   :config
;;   (progn
;;     ;; If irony server was never installed, install it.
;;     (unless (irony--find-server-executable) (call-interactively #'irony-install-server))

;;     (add-hook 'c++-mode-hook 'irony-mode)
;;     (add-hook 'c-mode-hook 'irony-mode)

;;     ;; Use compilation database first, clang_complete as fallback.
;;     ;;(setq-default irony-cdb-compilation-databases 'irony-cdb-json)

;;     (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
;;   ))

;;   ;; I use irony with company to get code completion.
;;   (req-package company-irony
;;     :require company irony
;;     :config
;;     (progn
;;       (eval-after-load 'company '(add-to-list 'company-backends 'company-irony))))

;;   ;; I use irony with flycheck to get real-time syntax checking.
;;   (req-package flycheck-irony
;;     :require flycheck irony
;;     :config
;;     (progn
;;       (eval-after-load 'flycheck '(add-hook 'flycheck-mode-hook #'flycheck-irony-setup))))

;;   ;; Eldoc shows argument list of the function you are currently writing in the echo area.
;;   (req-package irony-eldoc
;;     :require eldoc irony
;;     :config
;;     (progn
;;       (add-hook 'irony-mode-hook #'irony-eldoc)))
;;



;;;rtags
(req-package rtags
  :config
  (progn
    ;;(set-variable 'rtags-path "/home/ququ/.emacs.d/rtags/bin")
    (set-variable 'rtags-path "/home/tonki/.emacs.d/rtags/bin")
    (unless (rtags-executable-find "rc") (error "Binary rc is not installed!"))
    (unless (rtags-executable-find "rdm") (error "Binary rdm is not installed!"))
    ;;funclis
    (defun use-rtags (&optional useFileManager)
      (and (rtags-executable-find "rc")
	   (cond ((not (gtags-get-rootpath)) t)
		 ((and (not (eq major-mode 'c++-mode))
		       (not (eq major-mode 'c-mode))) (rtags-has-filemanager))
		 (useFileManager (rtags-has-filemanager))
		 (t (rtags-is-indexed)))))

    (defun tags-find-symbol-at-point (&optional prefix)
      (interactive "P")
      (if (and (not (rtags-find-symbol-at-point prefix)) rtags-last-request-not-indexed)
	  (gtags-find-tag)))
    (defun tags-find-references-at-point (&optional prefix)
      (interactive "P")
      (if (and (not (rtags-find-references-at-point prefix)) rtags-last-request-not-indexed)
	  (gtags-find-rtag)))
    (defun tags-find-symbol ()
      (interactive)
      (call-interactively (if (use-rtags) 'rtags-find-symbol 'gtags-find-symbol)))
    (defun tags-find-references ()
      (interactive)
      (call-interactively (if (use-rtags) 'rtags-find-references 'gtags-find-rtag)))
    (defun tags-find-file ()
      (interactive)
      (call-interactively (if (use-rtags t) 'rtags-find-file 'gtags-find-file)))
    (defun tags-imenu ()
      (interactive)
      (call-interactively (if (use-rtags t) 'rtags-imenu 'idomenu)))
    ;; RTAGS 设置键位
    (define-key c-mode-base-map (kbd "M-.") 'rtags-find-symbol-at-point)
    (define-key c-mode-base-map (kbd "M-,") 'rtags-location-stack-back)
    (define-key c-mode-base-map (kbd "M-;") 'rtags-find-file)
    (define-key c-mode-base-map (kbd "M-m") 'rtags-find-references-at-point)
    (define-key c-mode-base-map (kbd "C-.") 'rtags-find-symbol)
    (define-key c-mode-base-map (kbd "C-,") 'tags-find-references)
    (define-key global-map (kbd "C-<") (function rtags-find-virtuals-at-point))
    (define-key c-mode-base-map (kbd "M-<down>") 'rtags-next-match)
    (define-key c-mode-base-map (kbd "M-i") (function tags-imenu))
;;    (define-key c-mode-base-map (kbd "<C-tab>") (function company-complete))
    ;(define-key c-mode-base-map
    
    (defun fontify-string (str mode)
      "Return STR fontified according to MODE."
      (with-temp-buffer
	(insert str)
	(delay-mode-hooks (funcall mode))
	(font-lock-default-function mode)
	(font-lock-default-fontify-region (point-min) (point-max) nil)
	(buffer-string )))
    (defun rtags-eldoc-function()
      (let ((summary (rtags-get-summary-text)))
	(and summary
	     (fontify-string
	      (replace-regexp-in-string
	       "{{^}}*$" ""
	       (mapconcat
		(lambda (str) (if (= 0 (length str)) "//" (string-trim str )))
		(split-string summary "\r?\n")
		"  "))
	      major-mode))))
      
    (defun rtags-eldoc-mode()
      (interactive)
      (setq-local eldoc-documentation-function #'rtags-eldoc-function)
      (eldoc-mode 1))
    (add-hook 'c-mode-hook 'rtags-start-process-unless-running)
    (add-hook 'c++-mode 'rtags-start-process-unless-running)
    (add-hook 'c-mode-hook 'rtags-eldoc-mode)
    (add-hook 'c++-mode-hook 'rtags-eldoc-mode)
    (setq rtags-autostart-diagnostics t)
;;    (setq rtags-completions-enabled t)
    (rtags-diagnostics)
    (rtags-enable-standard-keybindings)
    (rtags-restart-process)
    ;;    (setq rtags-use-helm t)
    ;; Shutdown rdm when leaving emacs.
    (add-hook 'kill-emacs-hook 'rtags-quit-rdm)
    ))

;; TODO: Has no coloring! How can I get coloring?
;; (req-package helm-rtags
;;   :require helm rtags
;;   :config
;;   (progn
;;     (setq rtags-display-result-backend 'helm)
;;     ))

;; Use rtags for auto-completion.
(req-package company-rtags
  :require company rtags
  :config
  (progn
    (setq rtags-autostart-diagnostics t)
    (rtags-diagnostics)
    (setq rtags-completions-enabled t)
    (push 'company-rtags company-backends)
    (add-hook 'after-init-hook 'global-company-mode)
    (define-key c-mode-base-map (kbd "<C-tab>") (function company-complete))
    ))

;; Live code checking.
(req-package flycheck-rtags
  :require flycheck rtags
  :config
  (progn
    ;; ensure that we use only rtags checking
    ;; https://github.com/Andersbakken/rtags#optional-1
    (defun setup-flycheck-rtags ()
      (flycheck-select-checker 'rtags)
      (setq-local flycheck-highlighting-mode nil) ;; RTags creates more accurate overlays.
      (setq-local flycheck-check-syntax-automatically nil)
      (rtags-set-periodic-reparse-timeout 2.0)  ;; Run flycheck 2 seconds after being idle.
      )
    (add-hook 'c-mode-hook 'setup-flycheck-rtags)
    (add-hook 'c++-mode-hook 'setup-flycheck-rtags)
    ))
;;;;;;rtags ending ##################



;; (req-package projectile
;;   :require ivy
;;   :config
;;   (progn
;;     (projectile-global-mode)
;;     (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
;;     (setq projectile-completion-system 'ivy)
;;     ))

(req-package ivy
  :config
  (progn
    (add-hook 'after-init-hook 'ivy-mode)
    (setq ivy-use-virtual-buffers t)
    (setq ivy-count-format "(%d%d) ")
    (global-set-key (kbd "C-s") 'swiper)
    (global-set-key (kbd "M-x") 'counsel-M-x)
    (global-set-key (kbd "C-x C-f") 'counsel-find-file)
    (global-set-key (kbd "<f1> f") 'counsel-describe-function)
    (global-set-key (kbd "<f1> v") 'counsel-describe-variable)
    (global-set-key (kbd "<f1> l") 'counsel-find-library)
    (global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
    (global-set-key (kbd "<f2> u") 'counsel-unicode-char)
    (global-set-key (kbd "C-c C-r") 'ivy-resume)
    (global-set-key (kbd "<f6>") 'ivy-resume)
    (global-set-key (kbd "C-c g") 'counsel-git)
    ;;(global-set-key (kbd "C-x l") 'counsel-locate)
    ;;(global-set-key (kbd "C-v") 'ivy-scroll-down-command)
    ;;(global-set-key (kbd "M-v") 'ivy-scroll-up-command)
    ))
(req-package avy
  :config
  (progn
    (add-hook 'after-init-hook 'avy-setup-default)
    (global-set-key (kbd "M-s") 'avy-goto-char)
    ))

(req-package undo-tree
  :config
  (progn
    (global-undo-tree-mode)
    ))
(req-package yasnippet
  :config
  (progn
    (yas-global-mode 1)
    ))

(req-package counsel-projectile
  :require projectile
  :config
  (progn
 
    (counsel-projectile-mode t)
    (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
    (setq projectile-completion-system 'ivy)
    ))
;; =============================
;; python setup
;; =============================
;; enable elpy
(req-package elpy
  :require flycheck
  :config
  (progn
    (elpy-enable  )
    (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
    (add-hook 'elpy-mode-hook 'flycheck-mode)
    (define-key elpy-mode-map (kbd "<f7>") (kbd "C-u C-c C-c"))
    )
  )

;;------------------------------[blog]org-page---------------------
(req-package org-page
  :config
  (progn
    (setq op/repository-directory "~/play/blog/local_blog")
    (setq op/site-domain "https://alan717.github.io")
    (setq op/personal-github-link "https://github.com/alan717")                    ; if you want to show a personal github link.
    ;;(setq op/personal-avatar "assets/index.jpg")
    (setq op/site-main-title "山门凯的部落格")
    (setq op/site-sub-title "Blah blah...")
    (setq op/theme 'mdo)
    (setq op/personal-baidu-analytics-id "6774ee74c7919ee29204eb7d81ecf787")
))
;;;-----------------------------[blog]org-page--------------------------

(req-package-finish)
;;req-package ending 使用req-package必须在这个之前

(global-hl-line-mode t)
(global-linum-mode t)

;;;init.el end here

;;(load-theme 'moe-dark t)
(load-theme 'material t)




;;(use-package com
;;(load-theme 'solarized-dark t)
(nyan-mode t)
;;(use-package moe-theme
;;  :ensure t
;;  :config
(global-set-key (kbd "M-g") 'goto-line)
;;(global-set-key

(defvar default-tab-width 4)
(setq-default indent-tabs-mode nil)
;;(defvar c-default-style "Linux")
(defvar c-basic-offset 4)
;;关闭工具栏
(tool-bar-mode -1)
;;ido mode
;;(setq ido-enable-flex-matching t)
;;(setq ido-everywhere t)
;;(ido-mode 1)
;;(defalias 'list-buffers 'ibuffer)


(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
      backup-by-copying t    ; Don't delink hardlinks
;;  version-control t      ; Use version numbers on backups
      delete-old-versions t  ; Automatically delete excess backups
;;  kept-new-versions 20   ; how many of the newest versions to keep
;;  kept-old-versions 5    ; and how many of the old
      )
;;
;;(setq auto-save-file-name-transforms
;;  `((".*" "~/.emacs.d/auto-save-list" t)))


;;
;; (require 'ox-publish)
;; ;;(setq org-publish-project-alist
;; ;;      '(("blog"
;; ;;         :base-director
;; (setq org-publish-project-alist
;;        '(
;;          ;; page mydefination
;;          ("blog-notes"
;;           :base-directory "~/play/blog/notes"
;;           :html-head "<link rel=\"stylesheet\" type=\"text/css\" href=\"/css/org.css\"/>"
;;           :base-extension "org"
;;           :publishing-directory "~/play/blog/public_html/"
;;           :recursive t
;;           :publishing-function org-html-publish-to-html
;;           :headline-levels 4             ; Just the default for this project.
;;           :auto-preamble t
;;           :section-numbers nil
;;           :author "tonki"
;;           :email "akai@qq.com"
;;           :auto-sitemap t                ; Generate sitemap.org automagically...
;;           :sitemap-filename "sitemap.org"  ; ... call it sitemap.org (it's the default)...
;;           :sitemap-title "myblog"         ; ... with title 'Sitemap'.
;;           :sitemap-sort-files anti-chronologically
;;           :sitemap-file-entry-format "%d %t"
;;           )
;;          ("blog-static"
;;           :base-directory "~/play/blog/notes"
;;           :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
;;           :publishing-directory "~/play/blog/public_html/"
;;           :recursive t
;;           :publishing-function org-publish-attachment
;;           )
;;          ("blog" :components ("blog-notes" "blog-static"))
;;          ))




;;;-----------------------------[internet]w3m------------------------------
;; (require 'w3m)
;; (setq w3m-use-cookies t)
;; (setq w3m-home-page "https://www.dogedoge.com")
;; ;;(require 'mime-w3m)
;; (setq w3m-default-display-inline-images t)
;;(setq w3m-default-toggle-iniline-images t)

;;;-----------------------------[internet]w3m------------------------------
;;;;
;; 中文换行问题
(add-hook 'org-mode-hook
	  (lambda () (setq truncate-lines nil)))
;;(setq op/personal-disqus-shortname ""
;(setq op/personal-google-analytics-id "id of google analytics")

;;


;;;; 
;;;(global-unset-key (kbd "C-SPC"))
;;; init.el ends here
