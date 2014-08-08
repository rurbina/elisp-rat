; these are my php indentation settings
(provide 'ratasoft-php-style-hooks)

(defun ratasoft-php-mode-hook()
  "Ratasoft PHP mode settings."
  (setq
   indent-tabs-mode 0
   tab-width 4
   c-basic-offset 4
   )
  (c-set-offset 'arglist-intro c-basic-offset)
  (c-set-offset 'arglist-cont 0)
  (c-set-offset 'arglist-close 0)
)
(add-hook 'php-mode-hook 'ratasoft-php-mode-hook)
