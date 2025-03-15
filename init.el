;;; init.el --- Configuration file for Emacs >= 29.1  ;; -*- lexical-binding: t -*-
;;
;; Copyright (c) 2018-2025 Synchon Mandal
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

;; Package and source initialization
(with-eval-after-load 'package
  ;; Add package sources
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
  (add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/") t))

;; Personal info
(setq user-full-name "Synchon Mandal"             ;; set full name
      user-mail-address "synchon@protonmail.com") ;; set email address

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Basic setup
(setq inhibit-startup-screen t           ;; no splash screen
      initial-scratch-message "")        ;; empty *scratch*

(tool-bar-mode -1)                       ;; no tool bar
(horizontal-scroll-bar-mode -1)          ;; no horizontal toolbar
(scroll-bar-mode -1 )                    ;; no scroll bar
(global-display-line-numbers-mode 1)     ;; line numbers
(blink-cursor-mode -1)                   ;; no blinking cursor
(pixel-scroll-precision-mode)            ;; smooth scrolling
(set-frame-font "Iosevka Extended 15")   ;; font

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Modeline
(line-number-mode 1)     ;; line numbers in modeline
(column-number-mode 1)   ;; column number in modeline
(display-time-mode 1)    ;; display time in modeline
(size-indication-mode 1) ;; display file size in modeline

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Buffer
(global-prettify-symbols-mode)           ;; prettify symbols like lambda
(delete-selection-mode)                  ;; delete content while typing in marked region
(global-visual-line-mode)                ;; display visual line features like wrapping

(setq-default auto-revert-interval 1       ;; set auto-revert mode check to 1 second
              auto-revert-check-vc-info t) ;; check VC for auto-revert mode check
(global-auto-revert-mode)                  ;; auto-revert buffer from file on disk

(setq-default tab-width 2                  ;; use tab width of 2
              indent-tabs-mode nil)        ;; disable indent-tabs-mode

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Personal preferences
(setq create-lockfiles nil             ;; no lockfiles
      make-backup-files nil            ;; no backup files
      scroll-error-top-bottom t        ;; no error while scrolling past the window
      ring-bell-function 'ignore       ;; inhibit bell
      sentence-end-double-space nil    ;; use single space at sentence end
      confirm-kill-emacs 'y-or-n-p)    ;; quitting confirmation

(fset 'list-buffers 'ibuffer) ;; use ibuffer
(fset 'yes-or-no-p 'y-or-n-p) ;; use y/n instead of yes/no
(setq-default fill-column 88) ;; Restrict to 88 chars/line

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package emacs
  :delight
  (visual-line-mode)
  (beacon-mode)
  :init
  ;; TAB cycle if there are only few candidates
  (setq completion-cycle-threshold 3)
  ;; Enable indentation+completion using the TAB key.
  ;; `completion-at-point' is often bound to M-TAB.
  (setq tab-always-indent 'complete)
  :bind (("s-1" . text-scale-increase)
         ("s-2" . text-scale-decrease))
  :hook ((before-save . delete-trailing-whitespace)
         (prog-mode . electric-pair-mode))
  :config
  (setq auth-sources '("~/.authinfo"))
  ;; Prefer tree-sitter enhanced modes
  (setq major-mode-remap-alist
        '((yaml-mode . yaml-ts-mode)
          (bash-mode . bash-ts-mode)
          (js2-mode . js-ts-mode)
          (typescript-mode . typescript-ts-mode)
          (json-mode . json-ts-mode)
          (css-mode . css-ts-mode)
          (python-mode . python-ts-mode)
          (rust-mode . rust-ts-mode))))

;; Display matching parenthesis
(use-package paren
  :config
  (show-paren-mode 1))

;; Highlight line under cursor
(use-package hl-line
  :config
  (global-hl-line-mode 1))

;; winner-mode
(use-package winner
  :config
  (winner-mode 1)) ;; use C-c <left> and C-c <right> to switch window config

(use-package windmove
  :config
  (windmove-default-keybindings)                         ;; use shift + arrow keys to switch between visible buffers
  (add-hook 'org-shiftup-final-hook 'windmove-up)        ;; make windmove-up work in org mode
  (add-hook 'org-shiftleft-final-hook 'windmove-left)    ;; make windmove-left work in org mode
  (add-hook 'org-shiftdown-final-hook 'windmove-down)    ;; make windmove-down work in org mode
  (add-hook 'org-shiftright-final-hook 'windmove-right)) ;; make windmove-right work in org mode

;; Lazily move buffers
(use-package buffer-move
  :ensure t
  :bind (("C-S-<up>" . buf-move-up)
         ("C-S-<down>" . buf-move-down)
         ("C-S-<left>" . buf-move-left)
         ("C-S-<right>" . buf-move-right)))

(use-package dired
  :config
  ;; dired - reuse current buffer by pressing `a'

  ;; always delete and copy recursively
  ;; (setq dired-recursive-deletes 'always)
  ;; (setq dired-recursive-copies 'always)

  ;; if there is a dired buffer displayed in the next window, use its
  ;; current subdir, instead of the current subdir of this dired buffer
  (setq dired-dwim-target t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Flyspell
;; Spell checking using flyspell
(use-package flyspell
  :hook ((text-mode . flyspell-mode)
         (prog-mode . flyspell-prog-mode))
  :config
  ;; use `aspell' for ispell
  (setq ispell-program-name "aspell")
  ;; use `ultra' mode for aspell
  (setq ispell-extra-args '("--sug-mode=ultra" "--camel-case" "--master=en" "--lang=GB")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Org-mode
;; Org-mode customizations
;; (use-package org
;;   :hook ((org-mode . turn-on-org-cdlatex))
;;   :config
;;   (setq org-list-allow-alphabetical t))

;; ;; Improved section and subsections for org-mode
;; (use-package org-bullets
;;   :ensure t
;;   :hook (org-mode . org-bullets-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; General utilities
;; Restart Emacs from within Emacs
(use-package restart-emacs
  :ensure t)

;; Auto-package update
(use-package auto-package-update
  :ensure t
  :config
  (setq auto-package-update-prompt-before-update t
        auto-package-update-delete-old-versions t
        auto-package-update-hide-results t))

;; Fancy icons
(use-package nerd-icons
  :ensure t)

;; Dashboard for emacs
(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-startup-banner 'logo                  ;; use logo for banner
        dashboard-projects-backend 'project-el          ;; set project backend
        dashboard-items '((recents . 5)                 ;; restrict recents to 5
                          (projects . 5))               ;; restrict projects to 5
        dashboard-startupify-list '(dashboard-insert-banner
                                    dashboard-insert-newline
                                    dashboard-insert-banner-title
                                    dashboard-insert-newline
                                    dashboard-insert-navigator
                                    dashboard-insert-newline
                                    dashboard-insert-init-info
                                    dashboard-insert-items
                                    dashboard-insert-newline
                                    dashboard-insert-footer)
        dashboard-display-icons-p t                     ;; display icons on both GUI and terminal
        dashboard-icon-type 'nerd-icons                 ;; use `nerd-icons' package
        dashboard-set-file-icons t                      ;; show file icons
        dashboard-navigator-buttons                     ;; customize navigator buttons
        ;; Format: "(icon title help action face prefix suffix)"
        `(;; line1
          ((,(nerd-icons-mdicon "nf-md-file_edit")
            "init.el"
            "Open init.el"
            (lambda (&rest _) (crux-find-user-init-file)))
           (,(nerd-icons-mdicon "nf-md-update")
            "Update"
            "Update packages"
            (lambda (&rest _) (auto-package-update-now)))
           (,(nerd-icons-mdicon "nf-md-restart")
            "Restart"
            "Restart Emacs"
            (lambda (&rest _) (restart-emacs))))
          )
        ))

;; Neotree
(use-package neotree
  :ensure t
  :bind (("s-`" . neotree-toggle)                                   ;; bind toggle key
         ("C-a" . move-beginning-of-line))                          ;; respect global config
  :config
  (setq neo-theme (if (display-graphic-p) 'nerd 'arrow)             ;; set theme
        neo-smart-open t                                            ;; open current file in neotree
        neo-window-width 40))                                       ;; increase default neotree buffer width

;; Custom major mode name
(use-package delight
  :ensure t)

;; Native package called to remove mode from modeline
(use-package eldoc
  :delight)

;; Useful functions
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Superchargers zoom zoom ...

;; Minimalistic vertical completion for `M-x'
(use-package vertico
  :ensure t
  :init
  (vertico-mode))

;; Provide completion style (backend for completion) for a frontend UI
(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

;; Enhance in-buffer completion with popup
(use-package corfu
  :ensure t
  :init
  (global-corfu-mode)
  :custom
  (corfu-cycle t))       ;; Enable cycling for `corfu-next/previous'

;; Enable rich annotations in the minibuffer
(use-package marginalia
  :ensure t
  ;; Bind `marginalia-cycle' locally in the minibuffer. To make the binding
  ;; available in the *Completions* buffer, add it to the
  ;; `completion-list-mode-map'.
  :bind (:map minibuffer-local-map
         ("M-A" . marginalia-cycle))
  :init
  (marginalia-mode))

;; Enable fonts with rich annotations via `marginalia'
(use-package nerd-icons-completion
  :ensure t
  :after marginalia
  :hook (marginalia-mode . nerd-icons-completion-marginalia-setup)
  :config
  (nerd-icons-completion-mode))

;; Search and navigation
(use-package consult
  :ensure t
  :bind (;; C-c bindings in `mode-specific-map'
         ("C-c i" . consult-info)
         ([remap Info-search] . consult-info)
         ;; C-x bindings in `ctl-x-map'
         ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
         ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ;; M-g bindings in `goto-map'
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ;; M-s bindings in `search-map'
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
         ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
         ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)                 ;; orig. next-matching-history-element
         ("M-r" . consult-history))                ;; orig. previous-matching-history-element
  :init
  ;; Optionally configure the register formatting. This improves the register
  ;; preview for `consult-register', `consult-register-load',
  ;; `consult-register-store' and the Emacs built-ins.
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format)

  ;; Optionally tweak the register preview window.
  ;; This adds thin lines, sorting and hides the mode line of the window.
  (advice-add #'register-preview :override #'consult-register-window)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref))

;; Better window switching
(use-package ace-window
  :ensure t
  :bind (("C-x o" . ace-window)))

;; Search the kill-ring
(use-package browse-kill-ring
  :ensure t
  :config
  (browse-kill-ring-default-keybindings))

;; Suggest next key
(use-package which-key
  :ensure t
  :delight
  :hook (after-init . which-key-mode)
  :config
  (setq which-key-idle-delay 0.0))

;; undo-tree
(use-package undo-tree
  :ensure t
  :delight
  :init (global-undo-tree-mode 1)
  :config
  (defalias 'redo 'undo-tree-redo)
  (setq undo-tree-auto-save-history nil)  ;; don't save undo-tree history to file
  :bind (("C-z" . undo)
         ("C-S-z" . redo)))

;; Fix for reading $PATH
(use-package exec-path-from-shell
  :if (memq window-system '(mac ns x))
  :ensure t
  :config
  (exec-path-from-shell-initialize))

;; Walk through git revisions of a file
(use-package git-timemachine
  :ensure t
  :bind (("C-c C-g" . git-timemachine)))

;; LLM support via ollama
(use-package gptel
  :if (executable-find "ollama")
  :ensure t
  :config
  (setq gptel-model 'granite3.2:2b
        gptel-backend (gptel-make-ollama "Ollama"
                                         :host "localhost:11434"
                                         :stream t
                                         :models '(granite3.2:2b))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Programming
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Utilities
;; Improved parenthesis management
(use-package smartparens
  :ensure t
  :delight
  :hook (prog-mode . smartparens-mode))

;; Colored parenthesis
(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode))

;; Move line/region up/down
(use-package move-text
  :ensure t
  :bind (([(meta up)] . move-text-up)
         ([(meta down)] . move-text-down)))

;; Display inline color for a color code
(use-package rainbow-mode
  :ensure t
  :delight
  :hook (prog-mode . rainbow-mode)
  :config
  (setq rainbow-x-colors nil))

;; Indent guide
;; (use-package indent-guide
;;   :ensure t
;;   :hook (prog-mode . indent-guide-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Snippets
;; (use-package yasnippet
;;   :ensure t
;;   :hook ((prog-mode . yas-minor-mode)
;;          (go-mode . yas-minor-mode))
;;   :config
;;   (yas-reload-all))

;; (use-package yasnippet-snippets
;;   :ensure t
;;   :after yasnippet)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Editorconfig
;; Editorconfig support
;; (use-package editorconfig
;;   :ensure t
;;   :config
;;   (editorconfig-mode 1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Jupyter Notebook
(use-package ein
  :ensure t)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; LSP (Language Server Protocol) support
(use-package eglot
  :bind
  (:map eglot-mode-map
        ("C-c a". eglot-code-actions)
        ("C-c d" . eldoc)
        ("C-c f" . eglot-format-buffer)
        ("C-c r" . eglot-rename))
  :custom (eglot-send-changes-idle-item 0.1)
  :config
  (fset #'jsonrpc--log-event #'ignore))  ;; massive perf boost by skipping events

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Python
;; General config for python-mode
(use-package python
  :delight Python
  :hook ((python-mode . eglot-ensure)          ;; enable LSP
         (before-save . eglot-format-bufer)))  ;; format buffer via LSP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Go
;; General config for go-mode
(use-package go-mode
  :ensure t
  :delight Go
  :hook ((go-mode . eglot-ensure)             ;; enable LSP
         (before-save . gofmt-before-save)))  ;; run gofmt before save

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Haskell
;; Haskell support
;; (use-package haskell-mode
;;   :ensure t
;;   :hook ((subword-mode interactive-haskell-mode haskell-doc-mode) . haskell-mode))
;; :config
;; (add-hook 'haskell-mode-hook #'subword-mode)
;; (add-hook 'haskell-mode-hook #'interactive-haskell-mode)
;; (add-hook 'haskell-mode-hook #'haskell-doc-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Rust
;; Rust support
(use-package rust-mode
  :ensure t
  :delight Rust
  :init
  (setq rust-mode-treesitter-derive t)         ;; use tree-sitter
  :hook ((rust-mode . eglot-ensure)            ;; enable LSP
         (rust-mode . (lambda () (add-hook 'before-save-hook 'rust-format-buffer nil t)))))  ;; run rustfmt before save

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Elixir
;; Elixir support
;; (use-package elixir-mode
;;   :ensure t)
;; :hook (elixir-mode . (lambda ()(add-hook 'before-save-hook 'elixir-format nil t))))

;; Elixir tooling integration
;; (use-package alchemist
;;   :ensure t)

;; ;; Elixir backend for company
;; (use-package company-elixir
;;   :ensure t
;;   :hook (elixir-mode . company-elixir))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Dart
;; Dart support
(use-package dart-mode
  :ensure t
  :delight Dart)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; OCaml
;; OCaml support
;; (use-package tuareg
;;   :delight OCaml
;;   :ensure t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Markdown
;; Markdown support
(use-package markdown-mode
  :ensure t
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :hook ((gfm-mode . eglot-ensure)
         (markdown-mode . eglot-ensure))
  :config
  (setq markdown-fontify-code-blocks-natively t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; YAML
;; YAML support
(use-package yaml-mode
  :ensure t
  :hook ((yaml-mode . (lambda () (define-key yaml-mode-map "\C-m" 'newline-and-indent)))
         (yaml-mode . eglot-ensure))
  :config
  (add-to-list 'auto-mode-alist '("\\.yml\\'". yaml-mode)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Text + RST
;; Text + RST support
(use-package rst
  :ensure t
  :mode (("\\.txt\\'" . rst-mode)
         ("\\.rst\\'" . rst-mode)
         ("\\.rest\\'" . rst-mode))
  :hook (rst-mode . eglot-ensure))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; UI
;; Theme
(use-package color-theme-sanityinc-tomorrow
  :ensure t)

;; Enhanced modeline UI
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :config
  ;; set modeline height
  (setq doom-modeline-height 30)
  ;; use hud unstead of default bar
  (setq doom-modeline-hud t)
  ;; no limit for window width
  (setq doom-modeline-window-width-limit nil)
  ;; display icons if in GUI
  (setq doom-modeline-icon t)
  ;; display major mode icon if in GUI
  (setq doom-modeline-major-mode-icon t)
  ;; display color icon for major mode if in GUI
  (setq doom-modeline-major-mode-color-icon t)
  ;; display buffer name
  (setq doom-modeline-buffer-name t)
  ;; don't display minor mode
  (setq doom-modeline-minor-modes nil)
  ;; display LSP state
  (setq doom-modeline-lsp t)
  ;; display GitHub notificatons
  (setq doom-modeline-github t))

;; Distinguish between file-visiting windows and other windows
(use-package solaire-mode
  :ensure t
  :hook (after-init . solaire-global-mode))

;; Use tabs for active buffers
;; (use-package awesome-tab
;;   :ensure t
;;   :config
;;   (awesome-tab-mode t))

;; Finding cursor made easy
(use-package beacon
  :ensure t
  :delight
  :hook (after-init . beacon-mode))

;; Temporarily highlight changes from yanking, etc.
(use-package volatile-highlights
  :ensure t
  :delight
  :config
  (volatile-highlights-mode t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Utilities
;; Syntax checker
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

;; Expand selection by semantics
;; (use-package expand-region
;;   :ensure t
;;   :bind (("C-=" . er/expand-region)
;;          ("C--" . er/contract-region)))

;; Git interface
(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))

;; Ghub for Forge
(use-package ghub
  :ensure t
  :after magit)

;; Forge for Magit
(use-package forge
  :ensure t
  :after ghub)

;; Git diff highlight
(use-package diff-hl
  :ensure t
  :hook
  ((after-init . global-diff-hl-mode)
   (dired-mode-hook . diff-hl-dired-mode)
   (magit-pre-refresh-hook . diff-hl-magit-pre-refresh)
   (magit-post-refresh-hook . diff-hl-magit-post-refresh)))

;; Try a package before installing
(use-package try
  :ensure t)

;; Managing init system daemons
(use-package daemons
  :ensure t)

;; Config changes made through the customize UI will be stored here
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

(when (file-exists-p custom-file)
  (load custom-file))

;;; init.el ends here
(put 'dired-find-alternate-file 'disabled nil)
