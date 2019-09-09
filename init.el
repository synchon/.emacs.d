;;; init.el --- Configuration file for Emacs >= 24.3
;;
;; Copyright (c) 2018-2019 Synchon Mandal
;;
;; Author: Synchon Mandal <synchon@protonmail.com>
;; URL: https://github.com/synchon/emacs.d
;; Keywords: configuration

;; This file is not part of GNU Emacs.

;;; Commentary:

;; My Emacs configuration.

;;; License:

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Code:

;; Make startup faster by reducing the frequency of garbage
;; collection. The default is 800 kilobytes. Measured in bytes.
(setq gc-cons-threshold (* 50 1000 1000))

(require 'package)

;; stop second package load and improve startup time
(setq package-enable-at-startup nil)

;; add package sources
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/"))
(package-initialize)

;; setup use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

;; personal info
(setq user-full-name "Synchon Mandal"
      user-mail-address "synchon@protonmail.com")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; basic setup

;; no splash screen
(setq inhibit-startup-screen t)
;; empty *scratch*
(setq initial-scratch-message "")
;; no tool bar
(tool-bar-mode -1)
;; no horizontal toolbar
(horizontal-scroll-bar-mode -1)
;; no scroll bar
(scroll-bar-mode -1)
;; line numbers
(global-linum-mode 1)
;; no blinking cursor
(blink-cursor-mode -1)
;; font
(set-frame-font "FuraCode Nerd Font 14")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; modeline

;; line numbers in modeline
(line-number-mode 1)
;; column number in modeline
(column-number-mode 1)
;; display time in modeline
(display-time-mode 1)
;; display file size in modeline
(size-indication-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; buffer

;; prettify symbols like lambda
(global-prettify-symbols-mode 1)
;; delete content while typing in marked region
(delete-selection-mode 1)
;; auto-revert buffer from file on disk
(global-auto-revert-mode 1)
;; display visual line features like wrapping
(global-visual-line-mode 1)
;; tab-related config
(setq-default tab-width 2
              indent-tabs-mode nil
              tab-always-indent 'complete)
;; better scrolling
(setq scroll-margin 0
      scroll-conservatively 100000
      scroll-preserve-screen-position 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; personal preferences

(setq create-lockfiles nil             ;; no lockfiles
      make-backup-files nil            ;; no backup files
      scroll-error-top-bottom t        ;; no error while scrolling past the window
      ring-bell-function 'ignore       ;; inhibit bell
      sentence-end-double-space nil    ;; use single space at sentence end
      confirm-kill-emacs 'y-or-n-p     ;; quitting confirmation
      )

;; hooks

(add-hook 'before-save-hook 'delete-trailing-whitespace)
(add-hook 'prog-mode-hook 'electric-pair-mode)


;; use ibuffer
(fset 'list-buffers 'ibuffer)
;; use y/n instead of yes/no
(fset 'yes-or-no-p 'y-or-n-p)

;; Restrict to 80 chars/line
(setq-default fill-column 80)

;;;; flyspell-mode:
;; (setq ispell-program-name (executable-find "hunspell"))
;; (ispell-change-dictionary "den_US" t)
;; (add-hook 'text-mode-hook 'flyspell-mode)
;; (add-hook 'prog-mode-hook 'flyspell-prog-mode)
;; (add-hook 'lisp-mode 'flyspell-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package emacs
  :delight
  (visual-line-mode)
  (beacon-mode)
  :bind (("s-1" . text-scale-increase)
         ("s-2" . text-scale-decrease)))

;; display matching parenthesis
(use-package paren
  :config
  (show-paren-mode 1))

;; highlight line under cursor
(use-package hl-line
  :config
  (global-hl-line-mode 1))

;; winner-mode
(use-package winner
  :config
  ;; use C-c <left> and C-c <right> to switch window config
  (winner-mode 1))

(use-package windmove
  :config
  ;; use shift + arrow keys to switch between visible buffers
  (windmove-default-keybindings))

;; lazily move buffers
(use-package buffer-move
  :ensure t
  :bind (("C-S-<up>" . buf-move-up)
         ("C-S-<down>" . buf-move-down)
         ("C-S-<left>" . buf-move-left)
         ("C-S-<right>" . buf-move-right)))

(use-package dired
  :config
  ;; dired - reuse current buffer by pressing 'a'

  ;; always delete and copy recursively
  ;; (setq dired-recursive-deletes 'always)
  ;; (setq dired-recursive-copies 'always)

  ;; if there is a dired buffer displayed in the next window, use its
  ;; current subdir, instead of the current subdir of this dired buffer
  (setq dired-dwim-target t))

  ;; enable some really cool extensions like C-x C-j(dired-jump)
  ;; (require 'dired-x))

;; spell checker
(use-package flyspell
  :hook ((text-mode . flyspell-mode)
         (prog-mode . flyspell-prog-mode))
  :config
  (setq ispell-program-name "aspell"
        ispell-extra-args '("--sug-mode=ultra")))

;;; third-party packages

;; restart emacs from within emacs
(use-package restart-emacs
  :ensure t)

;; auto-package update
(use-package auto-package-update
  :ensure t
  :config
  (setq auto-package-update-prompt-before-update t)
  (setq auto-package-update-delete-old-versions t)
  (setq auto-package-update-hide-results t))

;; fancy icons
(use-package  all-the-icons
  :ensure t)

;; dashboard for emacs
(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-startup-banner 'logo)
  (setq dashboard-set-navigator t)
  (setq dashboard-items '((recents  . 5)
                          (projects . 5)))
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (setq dashboard-navigator-buttons
        ;; Format: "(icon title help action face prefix suffix)"
        `(;; line1
          ((,(all-the-icons-faicon "repeat" :height 1.0 :v-adjust 0.0)
            "Update"
            "Update packages"
            (lambda (&rest _) (auto-package-update-now)))
           (,(all-the-icons-faicon "refresh" :height 1.0 :v-adjust 0.0)
            "Restart"
            "Restart Emacs"
            (lambda (&rest _) (restart-emacs)))))))

;; delight
(use-package delight
  :ensure t)

;; native package called to remove mode from modeline
(use-package eldoc
  :delight)

;; smooth scrolling
(use-package sublimity
  :ensure t
  :hook (after-init . sublimity-mode)
  :config
  ;; scrolling configuration
  (setq sublimity-scroll-weight 10)
  (setq sublimity-scroll-drift-length 5))

;; set window dimensions based on golden ratio
(use-package golden-ratio
  :ensure t
  :hook (after-init . golden-ratio-mode))

;; useful functions
(use-package crux
  :ensure t
  :bind (("C-a" . crux-move-beginning-of-line)
         ("C-c I" . crux-find-user-init-file)
         ("C-c S" . crux-find-shell-init-file)
         ("C-<backspace>" . crux-kill-line-backwards)
         ("C-x 4 t" . crux-transpose-windows)
         ("C-c r" . crux-rename-file-and-buffer)
         ("C-x C-u" . crux-upcase-region)
         ("C-x C-l" . crux-downcase-region)
         ("C-x M-c" . crux-capitalize-region)))

;; ivy completion framework
(use-package ivy
  :ensure t
  :delight
  :hook (after-init . ivy-mode)
  :config
  ;; no regex by default
  (setq ivy-initial-inputs-alist nil))

;; ivy-enhanced search
(use-package swiper
  :ensure t
  :bind (("C-s" . swiper)))

;; ivy-enhanced narrowing
(use-package counsel
  :ensure t
  :bind (("M-x" . counsel-M-x)
         ("C-x C-f". counsel-find-file)))

;; counsel support for projectile
(use-package counsel-projectile
  :ensure t
  :hook (after-init . counsel-projectile-mode)
  :bind (("C-c p" . projectile-command-map)))

;; using flyspell with ivy
(use-package flyspell-correct-ivy
  :after flyspell
  :bind (:map flyspell-mode-map
              ("C-;" . flyspell-correct-word-generic))
  :custom (flyspell-correct-interface 'flyspell-correct-ivy))

;; better window switching
(use-package ace-window
  :ensure t
  :bind (("C-x o" . ace-window)))

;; text completion framework
(use-package company
  :ensure t
  :delight
  :hook (after-init . global-company-mode)
  :config
  (setq company-idle-delay 0.1)
  (setq company-show-numbers t)
  (setq company-tooltip-limit 10)
  (setq company-minimum-prefix-length 2)
  (setq company-tooltip-align-annotations t)
  (setq company-tooltip-flip-when-above t))

;; display fill-column
(use-package fill-column-indicator
  :ensure t
  :hook (python-mode . fci-mode))

;; indent guide
(use-package indent-guide
  :ensure t
  :hook (python-mode . indent-guide-mode))

;; company front-end with icons
;; (use-package company-box
;;   :ensure t
;;   :hook (company-mode . company-box-mode))

(use-package yasnippet
  :ensure t
  :hook (prog-mode . yas-minor-mode)
  :config
  (yas-reload-all))

(use-package yasnippet-snippets
  :ensure t
  :after yasnippet)

;; search the kill-ring
(use-package browse-kill-ring
  :ensure t
  :config
  (browse-kill-ring-default-keybindings))

;; suggest next key
(use-package which-key
  :ensure t
  :delight
  :hook (after-init . which-key-mode)
  :config
  (setq which-key-idle-delay 0.1))

;; undo-tree
(use-package undo-tree
  :ensure t
  :delight
  :init (global-undo-tree-mode 1)
  :config
  (defalias 'redo 'undo-tree-redo)
  :bind (("C-z" . undo)
         ("C-S-z" . redo)))

;; proper indentation
(use-package aggressive-indent
  :ensure t
  :delight
  :init (global-aggressive-indent-mode 1))

;; better parenthesis management
(use-package smartparens
  :ensure t
  :delight
  :hook (prog-mode . smartparens-mode))

;; move line/region up/down
(use-package move-text
  :ensure t
  :bind (([(meta up)] . move-text-up)
         ([(meta down)] . move-text-down)))

;; colored parenthesis
(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode))

;; inline color for a color code like hex
(use-package rainbow-mode
  :ensure t
  :delight
  :hook (prog-mode . rainbow-mode)
  :config
  (setq rainbow-x-colors nil))

;; macOS fix for reading $PATH
(use-package exec-path-from-shell
  :if (memq window-system '(mac ns))
  :ensure t
  :config
  (exec-path-from-shell-initialize))

;; project management
(use-package projectile
  :ensure t
  :delight
  :hook (after-init . projectile-mode)
  :config
  (setq projectile-completion-system 'ivy))

;; walk through revisions of a file
(use-package git-timemachine
  :ensure t
  :bind (("C-c C-g" . git-timemachine)))

;; better section and subsections for org mode
(use-package org-bullets
  :ensure t
  :hook (org-mode . org-bullets-mode))

;; htmlize
(use-package htmlize
  :ensure t)

;; open macOS apps
(use-package counsel-osx-app
  :ensure t
  :bind (("C-x C-o" . counsel-osx-app)))

;; editorconfig
(use-package editorconfig
  :ensure t
  :mode ("\\.editorconfig\\'" . editorconfig-mode))

;; better python support
(use-package anaconda-mode
  :ensure t
  :hook ((python-mode . anaconda-mode)
         (python-mode . anaconda-eldoc-mode)))

;; anaconda backend for company
(use-package company-anaconda
  :ensure t
  :config
  (add-to-list 'company-backends 'company-anaconda))

;; use virtualenv for python
(use-package auto-virtualenvwrapper
  :ensure t
  :hook (python-mode . auto-virtualenvwrapper-activate))

;; Haskell support
(use-package haskell-mode
  :ensure t
  :config
  (add-hook 'haskell-mode-hook #'subword-mode)
  (add-hook 'haskell-mode-hook #'interactive-haskell-mode)
  (add-hook 'haskell-mode-hook #'haskell-doc-mode))

;; Rust support
(use-package rust-mode
  :delight Rust
  :ensure t)

;; Golang support
(use-package go-mode
  :ensure t
  :delight Go
  :hook (before-save . gofmt-before-save)
  :config
  (use-package go-eldoc
    :ensure t
    :hook (go-mode . go-eldoc-setup)))

;; OCaml support
(use-package tuareg
  :delight OCaml
  :ensure t)

;; Markdown support
(use-package markdown-mode
  :ensure t
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :config
  (setq markdown-fontify-code-blocks-natively t))

;; Theme
(use-package zenburn-theme
  :ensure t
  :config
  (load-theme 'zenburn t))

;; modeline
(use-package mood-line
  :ensure t
  :hook (after-init . mood-line-mode))

;; beacon for finding cursor
(use-package beacon
  :ensure t
  :delight
  :hook (after-init . beacon-mode))

;; temporarily highlight changes from yanking, etc
(use-package volatile-highlights
  :ensure t
  :delight
  :config
  (volatile-highlights-mode t))

;; syntax checker
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

;; expand selection by semantics
(use-package expand-region
  :ensure t
  :bind (("C-=" . er/expand-region)
         ("C--" . er/contract-region)))

;; Git interface
(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))

(use-package diff-hl
  :ensure t
  :hook
  ((after-init . global-diff-hl-mode)
   (dired-mode-hook . diff-hl-dired-mode)
   (magit-post-refresh-hook . diff-hl-magit-post-refresh)))

;; improve speed typing
(use-package speed-type
  :ensure t)

;; try a package before installing
(use-package try
  :ensure t)

;; managing init system daemons
(use-package daemons
  :ensure t)

;; config changes made through the customize UI will be stored here
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

(when (file-exists-p custom-file)
  (load custom-file))

;;; init.el ends here
(put 'dired-find-alternate-file 'disabled nil)

;; Make gc pauses faster by decreasing the threshold.
(setq gc-cons-threshold (* 2 1000 1000))
