;;; early-init.el --- Configuration file for Emacs >= 29.1  ;; -*- lexical-binding: t -*-
;;
;; Copyright (c) 2018-2023 Synchon Mandal
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
;; This is set at 100 megabytes.
(setq gc-cons-threshold 100000000)

;; Supress byte-compile warnings.
(setq byte-compile-warnings '(not obsolete))
;; Suppress warnings from compilation and byte-compilation.
(setq warning-suppress-log-types '((comp) (bytecomp)))
;; Silently report async native compilation warnings and errors.
(setq native-comp-async-report-warnings-errors 'silent)

;; Increase amount of data read from the process to 1 megabyte.
(setq read-process-output-max (* 1024 1024))

;;; early-init.el ends here
