;;; init.el --- -*- lexical-binding: t no-byte-compile: t -*-
;;; Commentary:

;;;; Reference:
;;;; https://github.com/seagle0128/.emacs.d/tree/master
;;;; https://github.com/redguardtoo/emacs.d/tree/master
;;;; https://github.com/MiniApollo/kickstart.emacs
;;;; https://github.com/doomemacs/core
;;;; https://github.com/purcell/emacs.d
;;;; https://github.com/bbatsov/emacs.d
;;;; https://github.com/SystemCrafters/crafted-emacs
;;;; https://github.com/manateelazycat/lazycat-emacs
;;;; https://github.com/syl20bnr/spacemacs

;;; Code:

(setenv "MACOSX_DEPLOYMENT_TARGET" "27.0")

(use-package use-package
  :ensure nil
  :custom
  (use-package-always-ensure t)
  (use-package-always-defer t)
  (use-package-expand-minimally t)
  (use-package-enable-imenu-support t))

(use-package package
  :ensure nil
  :custom
  (package-enable-at-startup nil)
  :config
  (setq package-archives
        '(("gnu" . "https://elpa.gnu.org/packages/")
          ("melpa" . "https://melpa.org/packages/")
          ("nongnu" . "https://elpa.nongnu.org/nongnu/")))
  (setq package-quictstart t)
  (package-initialize))

(use-package emacs
  :ensure nil
  :config
  (setq-default tab-width 2)
	(setq-default create-lockfiles nil))

(use-package cus-edit
  :ensure nil
  :custom
  (custom-file (concat user-emacs-directory "custom.el")))

(use-package simple
  :ensure nil
  :hook
  (after-init . indent-tabs-mode)
  (prog-mode . line-number-mode)
  (prog-mode . column-number-mode)
  (prog-mode . size-indication-mode))

(use-package indent
  :ensure nil
  :config
  (setq standard-indent 2))

(use-package hl-line
  :ensure nil
  :hook
  (prog-mode . hl-line-mode))

(use-package display-line-numbers
  :ensure nil
  :hook
  (prog-mode . display-line-numbers-mode))

(use-package elec-pair
  :ensure nil
  :hook
  (prog-mode . electric-pair-mode))

(use-package paren
  :ensure nil
  :hook
  (prog-mode . show-paren-mode))

(use-package files
	:ensure nil
	:custom
	(make-backup-files nil)
	(auto-save-default nil))

(use-package recentf
	:ensure nil
	:hook
	(after-init . recentf-mode))

(use-package startup
	:ensure nil
	:custom
	(auto-save-list-file-prefix nil))

(use-package which-key
	:hook
	(after-init . which-key-mode)
	:config
	(setq which-key-idle-delay 0.5))

(use-package evil
	:init
	(setq evil-want-keybinding nil)
  :hook
  (after-init . evil-mode))

(use-package evil-escape
  :hook
  (evil-mode . evil-escape-mode)
  :config
  (setq-default evil-escape-key-sequence "jk")
  (setq-default evil-escape-delay 0.2))

(use-package evil-collection
	:hook
	(evil-mode . evil-collection-init))

(use-package evil-nerd-commenter
	:after evil
	:bind
	(:map evil-normal-state-map
				("gcc" . evilnc-comment-or-uncomment-lines))
	(:map evil-visual-state-map
				("gc" . evilnc-comment-or-uncomment-lines)))

(use-package evil-matchit
	:hook
	(evil-mode . global-evil-matchit-mode))

(use-package ivy
  :hook
  (after-init . ivy-mode)
  :config
  (setq ivy-height 17)
  (setq ivy-wrap t)
  (setq ivy-fixed-height-minibuffer t)
  (setq ivy-use-virtual-buffers t)
	(setq ivy-count-format "[%d/%d] ")
  (setq ivy-dynamic-exhibit-delay-ms 200)
	(setq ivy-initial-inputs-alist nil)
  (setq counsel-rg-base-command
        "rg --no-heading --line-number --color never %s .")
	(setq ivy-re-builders-alist
				'((t . ivy--regex-ignore-order)))
	(setq ivy-more-chars-alist
				'((counsel-rg . 2)
					(counsel-projectile-rg . 2))))

(use-package amx
	:hook
	(ivy-mode . amx-mode))

(use-package wgrep
	:config
	(setq wgrep-auto-save-buffer t))

(use-package counsel
  :hook
  (ivy-mode . counsel-mode)
	:bind
	(("C-c r" . counsel-recentf)
	 ("C-c w" . counsel-rg)
	 ("C-c j" . counsel-dired-jump)
	 ("C-c b" . counsel-ibuffer)))

(use-package swiper
  :bind
  (("C-s" . swiper-isearch)))

(use-package rainbow-delimiters
  :hook
  (prog-mode . rainbow-delimiters-mode))

(use-package helpful
  :bind
  (("C-h k" . helpful-key)
   ("C-h v" . helpful-variable)
   ("C-h x" . helpful-command)
   ("C-h f" . helpful-callable)
   ("C-h C-d" . helpful-at-point)))

(use-package magit
  :commands magit-status)

(use-package flycheck
  :hook
  (prog-mode . global-flycheck-mode)
  :bind
  (("M-n" . flycheck-next-error)
   ("M-p" . flycheck-previous-error)))

(use-package diredfl
	:hook
	(dired-mode . diredfl-mode))

(use-package symbol-overlay
	:hook
	(prog-mode . symbol-overlay-mode)
	:bind
	(("M-i" . symbol-overlay-put)
   ("M-S-n" . symbol-overlay-next)
   ("M-S-p" . symbol-overlay-prev)
   ("M-S-r" . symbol-overlay-remove-all))
	:config
	(setq symbol-overlay-idle-time 0.3))

(use-package diff-hl
	:hook
	(after-init . global-diff-hl-mode)
	(after-init . global-diff-hl-show-hunk-mouse-mode)
	(dired-mode . diff-hl-dired-mode)
	(magit-post-refresh . diff-hl-magit-post-refresh))

(use-package hl-todo
	:hook
	(prog-mode . global-hl-todo-mode)
	:config
	(setq hl-todo-highlight-punctuation ":")
  (setq hl-todo-text-modes nil)
	(setq hl-todo-keyword-faces
				'(("TODO" warning bold)
					("FIXME" error bold)
					("REVIEW" font-lock-keyword-face bold)
					("HACK" font-lock-constant-face bold)
					("DEPRECATED" font-lock-doc-face bold)
					("BUG" error bold)
					("XXX" font-lock-constant-face bold)
					("NOTE" success bold))))

(use-package ace-window
	:bind
	(([remap other-window] . ace-window))
	:config
	(setq aw-background nil)
	(setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))

(use-package company
	:hook
  (prog-mode . global-company-mode)
  :config
  (setq company-idle-delay 0.24)
	(setq company-minimum-prefix-length 1)
	(defun my/company-backend-with-yas (backend)
		(if (or (not (listp backend))
						(member 'company-yasnippet backend))
				(append (if (listp backend)
										backend
									(list backend))
								'(:with company-yasnippet))
			backend))
  (setq company-backends
        (mapcar #'my/company-backend-with-yas company-backends)))

(use-package yasnippet
	:hook
	(prog-mode . yas-minor-mode))

(use-package yasnippet-snippets
	:after yasnippet)

(provide 'init)
;;; init.el ends here
