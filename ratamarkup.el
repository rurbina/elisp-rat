;;
;; ratamarkup.el
;;
;; Major mode for Ratamarkup WYSIWYG
;;
;; See http://rat.netlsd.com/ratamarkup
;;

(defface ratamarkup-h1 '((t :bold t)) "Heading level 1")
(defface ratamarkup-b '((t :bold t)) "Strong text")
(defface ratamarkup-i '((t :slant 'italic)) "Emphazised text")

(define-derived-mode ratamarkup-mode text-mode "Ratamarkup"
  "Major mode for working with RataMarkup files in a WYSIWYG fashion."
  ()
  (
))

(defvar ratamarkup-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map "\e\b" 'ratamarkup-bold-region)
    map)
  "Keymap for ratamarkup-mode")


(add-to-list 'auto-mode-alist '("\\.rmk\\'" . ratamarkup-mode))
