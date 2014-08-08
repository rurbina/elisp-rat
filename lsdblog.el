;; lsdblog.el
;; Scripts para mi blog en http://rat.netlsd.com/
;;

(defun lsdblog-post-buffer-old ()
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

(defun lsdblog-post-buffer ()
  "Nuevo post en base al bufer actual"
  (interactive)
  (let (
	line
	(multiline "")
	(multiline-toggle nil)
	(multiline-marker (make-marker))
	(lsdblog-post-buffer (get-buffer-create "*lsdblog post*"))
	)
    (save-current-buffer (set-buffer lsdblog-post-buffer)
			 (erase-buffer))
    (save-excursion
      (goto-char 0)
      (while (not (eobp))
	(setq line (thing-at-point 'line))

	(if (and multiline-toggle (numberp (string-match "^&&$" line)))
	    (progn (setq multiline-toggle nil)
		   (setq line (concat (url-hexify-string multiline) "&"))
		   (setq multiline "")
		   ))

	;; multilining
	(if multiline-toggle (setq multiline (concat multiline line))

	  ;; not multilining
	  (setq line (replace-regexp-in-string (rx (* (any "\t\n\r ")) eos) "&" line))
	  (setq line (replace-regexp-in-string (rx "&&" eos) "&" line))
	  (setq line (replace-regexp-in-string (rx "=&" eos) "=" line))
	  (if (numberp (string-match "=$" line)) (setq multiline-toggle t))
	  (save-current-buffer (set-buffer lsdblog-post-buffer)
			       (insert line))
	  )

	(forward-line))

      ;; if you didn't close it...
      (if multiline-toggle
	  (progn (setq line (concat (url-hexify-string multiline) "&"))
		 (save-current-buffer (set-buffer lsdblog-post-buffer)
				      (insert line))
		 ))
      
      )

    ;; ok, now we got to do the request/post
    (with-current-buffer lsdblog-post-buffer
      (let ((url-request-method "post")
	    (url-request-data   (buffer-string))
	    (url-request-extra-headers '(("Content-Type" . "application/x-www-form-urlencoded"))))
	(setq url-request-data (replace-regexp-in-string (rx "&" eos) "" url-request-data))
	(url-retrieve "http://rat.netlsd.com/entry.cgi" 
		      (lambda (status)
			(switch-to-buffer (current-buffer))
			))))))
