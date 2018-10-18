;; Start med å presentere deg sjølv
(setq user-full-name "Aasmund Kvamme"
      user-mail-address "aasmund.kvamme@hvl.no")

;; Ulikt
(setq make-backup-files nil
      auto-save-default nil
      indent-tabs-mode nil
      ns-confirm-quit 1)

(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives '("gnu" . (concat proto "://elpa.gnu.org/packages/")))))
(package-initialize)

(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-16-le)

;; backwards compatibility as default-buffer-file-coding-system
;; is deprecated in 23.2.
(if (boundp 'buffer-file-coding-system)
    (setq-default buffer-file-coding-system 'utf-8)
  (setq default-buffer-file-coding-system 'utf-8))

;; Treat clipboard input as UTF-8 string first; compound text next, etc.
(setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))

;; opne svært store filar
(require 'vlf-setup)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(LaTeX-math-abbrev-prefix "'")
 '(TeX-electric-sub-and-superscript t)
 '(csv-header-lines 1)
 '(custom-safe-themes
   (quote
    ("bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" "fa2b58bb98b62c3b8cf3b6f02f058ef7827a8e497125de0254f56e373abee088" "89dd0329d536d389753111378f2425bd4e4652f892ae8a170841c3396f5ba2dd" "04589c18c2087cd6f12c01807eed0bdaa63983787025c209b89c779c61c3a4c4" default)))
 '(package-selected-packages
   (quote
    (org-journal json-navigator json-mode auto-complete ess-view ess-smart-underscore ess-smart-equals ess-R-data-view smartparens exec-path-from-shell better-defaults csv-mode web-mode js2-mode markdown-preview-mode markdown-mode+ markdown-mode god-mode keyfreq org-link-minor-mode vlf leuven-theme projectile dashboard julia-repl julia-shell julia-mode ess zenburn-theme spacemacs-theme use-package latex-preview-pane auctex color-theme cherry-blossom-theme helm)))
 '(unkillable-scratch t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Courier New" :foundry "outline" :slant normal :weight normal :height 120 :width normal)))))

;; Knytt Helm til M-x
(global-set-key (kbd "M-x") 'helm-M-x)


(require 'dashboard)
(dashboard-setup-startup-hook)
;; Set the title
(setq dashboard-banner-logo-title (concat "Velkommen til Emacs. r: Recent, m: Bookmarks, g: Refresh " ))
;; Set the banner
(setq dashboard-startup-banner 'logo)
;; Value can be
;; 'official which displays the official emacs logo
;; 'logo which displays an alternative emacs logo
;; 1, 2 or 3 which displays one of the text banners
;; "path/to/your/image.png" which displays whatever image you would prefer
(setq dashboard-items '((recents  . 10)
                        (bookmarks . 5)
;;                        (projects . 5)
                        (agenda . 5)
;;                        (registers . 5)
			))

;; slå av scroll-bar til høgre
(toggle-scroll-bar -1)

;; forkortingar
(load "~/.emacs.d/lisp/my-abbrev.el")

;; Flytt mellom vindu. NB! Denne kræsjer med org-filer
(windmove-default-keybindings)

;; ido-mode; nyttig
(ido-mode 1)
(setq ido-everywhere t)
(setq ido-enable-flex-matching t)

;; Tel opp kor mange gonger eg har brukt ulike kommandoar
;;(require 'keyfreq)
;;(keyfreq-mode 1)
;;(keyfreq-autosave-mode 1)
;; "keyfreq-show" lager lista

;; Markdown
(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

;; Tema
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'leuven t)

;; AUCTeX & friends
(electric-pair-mode 1)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)

;; Maxima
(add-to-list 'load-path "C:/maxima-5.41.0a/share/maxima/5.41.0a_dirty/emacs")
;; (add-to-list 'load-path "/usr/share/emacs/site-lisp/maxima/")
(autoload 'maxima-mode "maxima" "Maxima mode" t)
;; (autoload 'imaxima "imaxima" "Frontend for maxima with Image support" t)
(autoload 'maxima "maxima" "Maxima interaction" t)
;; (autoload 'imath-mode "imath" "Imath mode for math formula input" t)
;; (setq imaxima-use-maxima-mode-flag t)
(add-to-list 'auto-mode-alist '("\\.ma[cx]" . maxima-mode))

;; Generer eit 8-teikns passord til Canvas
(defun random-alnum ()
  (let* ((alnum "abcdefghijkmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ23456789")
         (i (% (abs (random)) (length alnum))))
    (substring alnum i (1+ i))))

(defun random-8-letter-string ()
  (interactive)
  (insert 
   (concat 
    (random-alnum)
    (random-alnum)
    (random-alnum)
    (random-alnum)
    (random-alnum)
    (random-alnum)
    (random-alnum)
    (random-alnum))))

(global-set-key (kbd "M-p") 'random-8-letter-string)


(defvar myPackages
  '(better-defaults
    elpy ;; add the elpy package
;;    material-theme
    ))
;; BASIC CUSTOMIZATION
;; --------------------------------------

;; (setq inhibit-startup-message t)   ;; hide the startup message
;; (load-theme 'material t)           ;; load material theme
;; (global-linum-mode t)              ;; enable line numbers globally
;; (setq linum-format "%4d \u2502 ")  ;; format line number spacing
;; Allow hash to be entered  
;; (global-set-key (kbd "M-3") '(lambda () (interactive) (insert "#")))

(elpy-enable)
;; (setq python-shell-interpreter "ipython"
;;      python-shell-interpreter-args "-i --simple-prompt")
(pyenv-mode)

(require 'smartparens-config)
(require 'ess-site)
;;(require 'ess-smart-underscore)


;;org-journal
(require 'org-journal)
(setq org-journal-dir "C:/Users/Aasmund/AppData/Roaming/.emacs.d")
