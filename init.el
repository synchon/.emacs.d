;;; init.el --- Configuration file for Emacs >= 24.3
;;
;; Copyright (c) 2018-2021 Synchon Mandal
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
;; This is set at 100 mb
(setq gc-cons-threshold 100000000)

;; Increase amount of data read from the process to 1 mb
(setq read-process-output-max (* 1024 1024))

(require 'package)

;; Stop second package load and improve startup time
(setq package-enable-at-startup nil)

;; Add package sources
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/"))
(package-initialize)

;; Setup 'use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

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
(set-frame-font "IBM Plex Mono 14")      ;; font

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Modeline
(line-number-mode 1)     ;; line numbers in modeline
(column-number-mode 1)   ;; column number in modeline
(display-time-mode 1)    ;; display time in modeline
(size-indication-mode 1) ;; display file size in modeline

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Buffer
(global-prettify-symbols-mode 1)           ;; prettify symbols like lambda
(delete-selection-mode 1)                  ;; delete content while typing in marked region
(global-auto-revert-mode 1)                ;; auto-revert buffer from file on disk
(global-visual-line-mode 1)                ;; display visual line features like wrapping

(setq-default tab-width 2                  ;; use tab width of 2
              indent-tabs-mode nil         ;; disable indent-tabs-mode
              tab-always-indent 'complete) ;; complete indent while using tab

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Personal preferences
(setq create-lockfiles nil             ;; no lockfiles
      make-backup-files nil            ;; no backup files
      scroll-error-top-bottom t        ;; no error while scrolling past the window
      ring-bell-function 'ignore       ;; inhibit bell
      sentence-end-double-space nil    ;; use single space at sentence end
      confirm-kill-emacs 'y-or-n-p     ;; quitting confirmation
      )

(fset 'list-buffers 'ibuffer) ;; use ibuffer
(fset 'yes-or-no-p 'y-or-n-p) ;; use y/n instead of yes/no
(setq-default fill-column 88) ;; Restrict to 88 chars/line

;; Hooks
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(add-hook 'prog-mode-hook 'electric-pair-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package emacs
  :delight
  (visual-line-mode)
  (beacon-mode)
  :bind (("s-1" . text-scale-increase)
         ("s-2" . text-scale-decrease))
  ;; :hook ((before-save . delete-trailing-whitespace)
  ;;        (prog-mode . electric-pair-mode)))
  :config
  (setq auth-sources '("~/.authinfo")))

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
  ;; dired - reuse current buffer by pressing 'a'

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
  ;; use `aspell` for ispell
  (setq ispell-program-name "aspell")
  ;; use `ultra` mode for aspell
  (setq ispell-extra-args '("--sug-mode=ultra" "--camel-case" "--lang=en_UK")))

;; Using flyspell with ivy
(use-package flyspell-correct-ivy
  :after flyspell
  :bind (:map flyspell-mode-map
              ("C-;" . flyspell-correct-word-generic))
  :custom (flyspell-correct-interface 'flyspell-correct-ivy))

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
(use-package all-the-icons
  :if (display-graphic-p)
  :ensure t)

;; Dashboard for emacs
(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-startup-banner 'logo                  ;; use logo for banner
        dashboard-set-navigator t                       ;; show navigator
        dashboard-items '((recents . 5) (projects . 5)) ;; restrict recents and projects to 5
        dashboard-set-heading-icons t                   ;; show icons
        dashboard-set-file-icons t                      ;; show file icons
        dashboard-navigator-buttons                     ;; customize navigator buttons
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

;; Project management
(use-package projectile
  :ensure t
  :delight
  :hook (after-init . projectile-mode)
  :config
  ;; enable caching for large projects
  (setq projectile-enable-caching t)
  ;; use 'ivy' for completion
  (setq projectile-completion-system 'ivy))

;; Neotree
(use-package neotree
  :ensure t
  :bind (("s-`" . neotree-toggle)                                   ;; bind toggle key
         ("C-a" . move-beginning-of-line))                          ;; respect global config
  :config
  (setq neo-theme (if (display-graphic-p) 'icons 'arrow)            ;; set theme
        neo-smart-open t                                            ;; open current file in neotree
        projectile-switch-project-action 'neotree-projectile-action ;; integrate with projectile-switch-project
        neo-window-width 40))                                       ;; increase default neotree buffer width

;; Custom major mode name
(use-package delight
  :ensure t)

;; Native package called to remove mode from modeline
(use-package eldoc
  :delight)

;; Smooth scrolling
;; (use-package sublimity
;;   :ensure t
;;   :hook (after-init . sublimity-mode)
;;   :config
;;   (setq sublimity-scroll-weight 10        ;; set scroll weight
;;         sublimity-scroll-drift-length 5)) ;; set scroll drift length

;; Set window dimensions based on golden ratio
(use-package golden-ratio
  :ensure t
  :hook (after-init . golden-ratio-mode))

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

;; Generic completion framework for 'M-x'
(use-package ivy
  :ensure t
  :delight
  :hook (after-init . ivy-mode)
  :config
  (setq ivy-initial-inputs-alist nil)) ;; no regex by default

;; 'ivy'-enhanced versions of common emacs commands
(use-package counsel
  :ensure t
  :bind (("M-x" . counsel-M-x)
         ("C-x C-f". counsel-find-file)))

;; 'ivy'-enhanced search alternative to 'isearch'
(use-package swiper
  :ensure t
  :bind (("C-s" . swiper)))

;; Better window switching
(use-package ace-window
  :ensure t
  :bind (("C-x o" . ace-window)))

;; In-buffer text auto-completion framework
(use-package company
  :ensure t
  :delight
  :hook (after-init . global-company-mode)
  :config
  (setq company-idle-delay 0.0              ;; displays toolip with a delay of 0.0
        company-show-quick-access nil       ;; do not show numbers for hints
        company-tooltip-limit 10            ;; max. result of 10 in tooltip
        company-minimum-prefix-length 1     ;; requires 1 chars to start auto-completion
        company-tooltip-align-annotations t ;; align tooltip annotations
        company-tooltip-flip-when-above t)) ;; flip direction when displayed above

;; 'company' front-end with icons
;; (use-package company-box
;;   :ensure t
;;   :hook (company-mode . company-box-mode))

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

;; Proper indentation for code blocks
(use-package aggressive-indent
  :ensure t
  :delight
  :init (global-aggressive-indent-mode 1))

;; macOS fix for reading $PATH
(use-package exec-path-from-shell
  :if (memq window-system '(mac ns))
  :ensure t
  :config
  (exec-path-from-shell-initialize))

;; Counsel support for projectile
(use-package counsel-projectile
  :ensure t
  :hook (after-init . counsel-projectile-mode)
  :bind (("C-c p" . projectile-command-map)))

;; Walk through git revisions of a file
(use-package git-timemachine
  :ensure t
  :bind (("C-c C-g" . git-timemachine)))

;; htmlize
;; (use-package htmlize
;;   :ensure t)

;; Open macOS apps
(use-package counsel-osx-app
  :if (memq window-system '(mac ns))
  :ensure t
  :bind (("C-x C-o" . counsel-osx-app)))

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
;;   (yas-reload-all)
;;   (yas-global-mode))

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
;; LSP support via lsp-mode
(use-package lsp-mode
  :ensure t
  :hook (
         (lsp-mode . lsp-enable-which-key-integration) ;; enable which-key integration
         (prog-mode . lsp-deferred))  ;; automatically start 'lsp' for programming
  :commands (lsp lsp-deferred)
  :config
  ;; prefix for lsp-command-keymap
  (setq lsp-keymap-prefix "C-c l")
  ;; don't warn for no client found
  (setq lsp-warn-no-matched-clients nil))

;; UI for lsp-mode via lsp-ui
(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode)

;; lsp-mode ivy integration
(use-package lsp-ivy
    :ensure t
    :commands lsp-ivy-workspace-symbol)

;; lsp-mode treemacs integration
;; (use-package lsp-treemacs
;;   :ensure t
;;   :config (lsp-treemacs-sync-mode 1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Python
;; General config for python-mode
(use-package python
  :delight Python
  :hook (python-mode . tree-sitter-hl-mode))

;; LSP for Python
(use-package lsp-pyright
  :ensure t
  :hook (python-mode . lsp-deferred))

;; (defun python-remove-unused-imports()
;;   ;; Removes unused imports and unused variables with autoflake.
;;   (interactive)
;;   (if (executable-find "autoflake")
;;       (progn
;;         (shell-command (format "autoflake --remove-all-unused-imports -i %s"
;;                                (shell-quote-argument (buffer-file-name))))
;;         (revert-buffer t t t))
;;     (warn "python-mode: Cannot find autoflake executable."))))

;; ;; Format code as per black code formatter rules
;; (use-package blacken
;;   :ensure t
;;   :delight
;;   :hook (python-mode . blacken-mode)
;;   :custom (blacken-line-length 79))

;; ;; Sort imports as per isort
;; (use-package py-isort
;;   :ensure t
;;   :after python
;;   :hook ((python-mode . pyvenv-mode)
;;          (before-save . py-isort-before-save)))

;; (use-package pyenv-mode
;;   :after python
;;   :hook ((python-mode . pyenv-mode)
;;          (projectile-switch-project . projectile-pyenv-mode-set))
;;   :custom (pyenv-mode-set "3.8.5")
;;   :preface
;;   (defun projectile-pyenv-mode-set ()
;;     ;; Set pyenv version matching project name.
;;     (let ((project (projectile-project-name)))
;;       (if (member project (pyenv-mode-versions))
;;           (pyenv-mode-set project)
;;         (pyenv-mode-unset)))))

;; ;; Virtualenv support
;; (use-package pyvenv
;;   :ensure t
;;   :after python
;;   :hook (python-mode . pyvenv-mode)
;;   :custom
;;   (pyvenv-default-virtual-env-name "env")
;;   (pyvenv-mode-line-indicator '(pyvenv-virtual-env-name ("[venv:"
;;                                                          pyvenv-virtual-env-name "]"))))

;; Poetry support
(use-package poetry
  :ensure t
  :bind ("C-x p" . poetry))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Go
;; General config for go-mode
(use-package go-mode
  :ensure t
  :delight Go)

;; LSP support (https://github.com/golang/tools/blob/master/gopls/doc/emacs.md#loading-lsp-mode-in-emacs)
;; Set up before-save hooks to format buffer and add/delete imports.
;; Make sure you don't have other gofmt/goimports hooks enabled.
(defun lsp-go-install-save-hooks ()
  ;; Adds hooks for go mode using LSP.
  ;; format buffer using gofmt
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  ;; organize imports using goimports
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

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
;; (use-package rust-mode
;;   :delight Rust
;;   :ensure t)

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
;; ;; LSP for Dart
;; (use-package lsp-dart
;;   :ensure t
;;   :hook (dart-mode . lsp))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; OCaml
;; OCaml support
;; (use-package tuareg
;;   :delight OCaml
;;   :ensure t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Markdown
;; Markdown support
;; (use-package markdown-mode
;;   :ensure t
;;   :mode (("README\\.md\\'" . gfm-mode)
;;          ("\\.md\\'" . markdown-mode)
;;          ("\\.markdown\\'" . markdown-mode))
;;   :config
;;   (setq markdown-fontify-code-blocks-natively t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; YAML
;; YAML support
;; (use-package yaml-mode
;;   :ensure t
;;   :hook (yaml-mode . (lambda () (define-key yaml-mode-map "\C-m" 'newline-and-indent)))
;;   :config
;;   (add-to-list 'auto-mode-alist '("\\.yml\\'". yaml-mode)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; DAP (Debugging Adapter Protocol) support
(use-package dap-mode
  :ensure t
  :config
  (dap-mode 1)
  ;; The modes below are optional
  (dap-ui-mode 1)
  ;; enables mouse hover support
  (dap-tooltip-mode 1)
  ;; use tooltips for mouse hover
  ;; if it is not enabled `dap-mode' will use the minibuffer.
  (tooltip-mode 1)
  ;; displays floating panel with debug buttons
  ;; requies emacs 26+
  (dap-ui-controls-mode 1)
  (require 'dap-python))

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
  (setq doom-modeline-icon (display-graphic-p))
  ;; display major mode icon if in GUI
  (setq doom-modeline-major-mode-icon (display-graphic-p))
  ;; display color icon for major mode if in GUI
  (setq doom-modeline-major-mode-color-icon (display-graphic-p))
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

;; Improve speed typing
(use-package speed-type
  :ensure t)

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
