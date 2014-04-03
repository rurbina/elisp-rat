;; lsdblog.el
;; Scripts para mi blog en http://rat.netlsd.com/

(defun lsdblog-post-buffer ()
  "Nuevo post en base al buffer actual"
  (interactive)
  (with-current-buffer
      (save-excursion
	(let (line (accumulator "") (accumulating nil) (mark1 (make-marker)))
	  (goto-char 0)
	  (while (not (eobp))
	    (setq line (thing-at-point 'line))
	    

	    (if accumulating ; we're accumulating
		(progn 
		  (if (numberp (string-match "^&&$" line)) ;stop accumulating !
		      (progn 
			(setq accumulating nil)
			(with-current-buffer "*lsdblog-post-buffer*"
			  (goto-char (point-max))
			  (insert (concat (url-hexify-string accumulator) "&"))
			  ))
		    (setq accumulator (concat accumulator line))))
	      
	      (if (numberp (string-match "=$" line)) ; no accumulating but beginning now
		  (progn 
		    (setq accumulating t)
		    (setq line (replace-regexp-in-string "[\r\n]+$" "" line))
		    )
		(setq line (replace-regexp-in-string "[\r\n]+$" "&" line))
		)
	      
	      (with-current-buffer "*lsdblog-post-buffer*" ; insert line
		(save-excursion 
		  (goto-char (point-max))
		  (insert line)
		  ))
	      )
	    (forward-line)
	    )

	  (if accumulating ; maybe you didn't close your multiline arg
	      (progn
		(with-current-buffer "*lsdblog-post-buffer*"
		  (goto-char (point-max))
		  (insert (concat (url-hexify-string accumulator)))
		  )))
	  
	  ))))
