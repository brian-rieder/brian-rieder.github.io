(setq frame-title-format "%b")
(put 'narrow-to-region 'disabled nil)
(fset 'yes-or-no-p 'y-or-n-p)
(menu-bar-mode -1) ; no menu bar
(set-face-attribute 'default nil :font "Source Code Pro")
(blink-cursor-mode 0)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#ad7fa8" "#8cc4ff" "#eeeeec"])
 '(column-number-mode t)
 '(custom-enabled-themes (quote (tsdh-dark)))
 '(inhibit-startup-screen t)

 '(display-time-mode t)
 '(fringe-mode 0 nil (fringe))
 '(icomplete-mode t)
 '(initial-frame-alist (quote ((menu-bar-lines . 0) (tool-bar-lines . 0))))
 '(scroll-bar-mode nil)
 '(set-fill-column 80)
 '(tool-bar-mode nil)
 '(tooltip-mode nil))  ; Get rid of tooltips
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(show-paren-mode 1)
(global-linum-mode 1)
;;(setq linum-format “%d“)

(defun save-all () (interactive) (save-some-buffers t))

(global-set-key [(super w)] 'count-words)
(global-set-key [(super f)] 'flyspell-mode)
(global-set-key [(super k)] 'kill-this-buffer)
(global-set-key [(super K)] 'kill-some-buffers)
(global-set-key (kbd "C-;") 'comment-region)
(global-set-key (kbd "C-:") 'uncomment-region)
(global-set-key (kbd "C-+") 'text-scale-adjust)
(global-set-key (kbd "C--") 'text-scale-adjust)
(global-set-key (kbd "C-0") 'text-scale-adjust)
(global-set-key [(super l)] 'save-all)            ; save-all, (super s) not work
(global-set-key [(super z)] 'undo)                ; undo. Press C-r to make redo
(global-set-key [(super x)] 'kill-region)         ; cut
(global-set-key [(super c)] 'copy-region-as-kill) ; copy
(global-set-key [(super v)] 'yank)                ; paste
(global-set-key (kbd "M-v") 'yank-pop)            ; paste previous
(global-set-key (kbd "M-g") 'goto-line)           ; no need for facemenu in normal editing

;; Navigation, press [f1] to mark a point, and then M-f1 to jump back to it
(global-set-key [f1] (lambda ()(interactive) (point-to-register 1)))
(global-set-key [(meta f1)] (lambda ()(interactive) (jump-to-register 1)))
(global-set-key [f2] (lambda ()(interactive) (point-to-register 2)))
(global-set-key [(meta f2)] (lambda ()(interactive) (jump-to-register 2)))

;; Shift+Arrow to move between buffers
(when (fboundp 'windmove-default-keybindings)
   (windmove-default-keybindings))

;;; ---------------------------------------------------------- Copy to Clipboard
;; http://hugoheden.wordpress.com/2009/03/08/copypaste-with-emacs-in-terminal/
;; I prefer using the "clipboard" selection (the one the
;; typically is used by c-c/c-v) before the primary selection
;; (that uses mouse-select/middle-button-click)
(setq x-select-enable-clipboard t)

;; If emacs is run in a terminal, the clipboard- functions have no
;; effect. Instead, we use of xsel, see
;; http://www.vergenet.net/~conrad/software/xsel/ -- "a command-line
;; program for getting and setting the contents of the X selection"
(unless window-system
 (when (getenv "DISPLAY")
  ;; Callback for when user cuts
  (defun xsel-cut-function (text &optional push)
    ;; Insert text to temp-buffer, and "send" content to xsel stdin
    (with-temp-buffer
      (insert text)
      ;; I prefer using the "clipboard" selection (the one the
      ;; typically is used by c-c/c-v) before the primary selection
      ;; (that uses mouse-select/middle-button-click)
      (call-process-region
       (point-min) (point-max) "xsel" nil 0 nil "--clipboard" "--input")))
  ;; Call back for when user pastes
  (defun xsel-paste-function()
    ;; Find out what is current selection by xsel. If it is different
    ;; from the top of the kill-ring (car kill-ring), then return
    ;; it. Else, nil is returned, so whatever is in the top of the
    ;; kill-ring will be used.
    (let ((xsel-output (shell-command-to-string "xsel --clipboard --output")))
      (unless (string= (car kill-ring) xsel-output)
xsel-output )))
  ;; Attach callbacks to hooks
  (setq interprogram-cut-function 'xsel-cut-function)
  (setq interprogram-paste-function 'xsel-paste-function)
  ;; Idea from
  ;; http://shreevatsa.wordpress.com/2006/10/22/emacs-copypaste-and-x/
  ;; http://www.mail-archive.com/help-gnu-emacs@gnu.org/msg03577.html
 ))


;;; ------------------------------------------------------------ smarter-backups

(setq
   backup-by-copying t      ; don't clobber symlinks
   backup-directory-alist
    '(("." . "~/.emacs-backups"))    ; don't litter my filesytem
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   version-control t)       ; use versioned backups

;;; -------------------------------------------------------------- Smooth-Scroll

(defun smooth-scroll (increment)
 ;; scroll smoothly by intercepting the mouse wheel and
 ;; turning its signal into a signal which
 ;; moves the window one line at a time, and waits for
 ;; a period of time between each move
  (scroll-up increment) (sit-for 0.05)
  (scroll-up increment) (sit-for 0.02)
  (scroll-up increment) (sit-for 0.02)
  (scroll-up increment) (sit-for 0.05)
  (scroll-up increment) (sit-for 0.06)
  (scroll-up increment))
(global-set-key [(mouse-5)] '(lambda () (interactive) (smooth-scroll 1)))
(global-set-key [(mouse-4)] '(lambda () (interactive) (smooth-scroll -1)))

(setq scroll-preserve-screen-position t) ;don't move the cursor when scrolling

;;------------------------------------------------------------------------
(set-face-attribute 'default (selected-frame) :height 100)

;; M+up/down to move lines up or down
(defun move-line-up ()
  (interactive)
  (transpose-lines 1)
  (forward-line -2))

(defun move-line-down ()
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1))

(global-set-key (kbd "M-<up>") 'move-line-up)
(global-set-key (kbd "M-<down>") 'move-line-down)

;;----------------------------------------------------------------ORG MODE

(setq org-todo-keywords
       '((sequence "TODO" "WAITING" "WORKING" "STARTED" "DONE")))
(setq org-todo-keyword-faces
           '( ("WAITING" . "blue") ("WORKING" . "yellow") ("STARTED" . "pink") ) )
(setq org-export-with-sub-superscripts nil)
(setq org-replace-disputed-keys t)

;;------------------------------------------------------------------------

(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                          ("marmalade" . "https://marmalade-repo.org/packages/")
                          ("melpa" . "http://melpa.milkbox.net/packages/")))


;;---------------------------------------------------------Python IDE Config
(let ((default-directory "~/.emacs.d/"))
  (setq load-path
        (append
         (let ((load-path (copy-sequence load-path))) ;; Shadow
           (append 
            (copy-sequence (normal-top-level-add-to-load-path '(".")))
            (normal-top-level-add-subdirs-to-load-path)))
         load-path)))

(require 'package)

;; Projectile: Project management
;; (require 'projectile)
;; (projectile-global-mode)

;; Auto-complete...
(require 'auto-complete-config)
(ac-config-default)
(setq ac-show-menu-immediately-on-auto-complete t)

;; ;; Jedi
;; (require 'jedi)
;; ;; hook up to auto-complete
;; (add-to-list 'ac-sources 'ac-source-jedi-direct)
;; ;; enable for python mode
;; (add-hook 'python-mode-hook 'jedi:setup)

;; EPC: Depedency... works as the glue (middleware)

;;---------------------------------------------------------------multiple-cursors
(require 'multiple-cursors)

;; When you have an active region that spans multiple lines, the following will
;; add a cursor to each line:
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)

;; When you want to add multiple cursors not based on continuous lines, but based on
;; keywords in the buffer, use:
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

(global-set-key (kbd "C-S-<mouse-1>") 'mc/add-cursor-on-click)

;;----------------------------------------------------------------------yasnippet
(require 'yasnippet)
(yas-global-mode 1)
