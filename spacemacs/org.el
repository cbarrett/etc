(defun my/org-babel-execute-included-src-blocks ()
  "Find and execute code blocks included via #+INCLUDE."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    ;; Look for `#+INCLUDE:` directive
    (while (re-search-forward "^\\s-*#\\+INCLUDE: \"\\([^\"]+\\)\\(?:::\\([^ \"]+\\)?\\)\"" nil t)
      ;; Extract and trim the file and optional search term
      (let* ((file (match-string 1))
             (search-term (match-string 2)))
        ;; Early return if search term starts with *
        (when (and search-term (string-prefix-p "*" search-term))
          (message "Fuzzy headline matching not supported, skipping execution for: %s" search-term)
          (return))
        ;; Process the file and search term
        (with-temp-buffer
          (insert-file-contents file)
          (org-mode)
          (goto-char (point-min))
          (if (not search-term)
              ;; No search term, process the entire file
              (progn
                (org-babel-map-src-blocks nil
                  (org-babel-execute-src-block))
                (message "Executed all blocks in file: %s" file))
            ;; Process specific named block
            (if (re-search-forward (format "^\\s-*#\\+name:\\s-*%s\\b" search-term) nil t)
                (progn
                  (org-babel-next-src-block)
                  (org-babel-execute-src-block)
                  (message "Executed block for search-term: %s in file: %s" search-term file))
              (message "Match not found for search-term: %s in file: %s" search-term file))))))))

(defun my/org-babel-execute-named-src-block (block-name)
  "Execute the named source block using org-babel-goto-named-src-block."
  (interactive "Enter the block name: ") ; Allow interactive use
  (save-excursion
    (org-babel-goto-named-src-block block-name)
    (org-babel-execute-src-block)))

;; Function to format Emacs Lisp source blocks
(defun my/org-babel-elisp-autofmt (&optional fill-column-override)
  (interactive "p")
  (when (string= (or (org-element-property :language (org-element-at-point)) "") "emacs-lisp")
    (message "Formating Emacs Lisp src block...")
    (let ((beg (org-element-property :begin (org-element-at-point)))
          (end (org-element-property :end (org-element-at-point)))
          (original-fill-column (or fill-column-override fill-column))
          (current-pos (point)))
      (save-excursion
        (goto-char beg)
        (re-search-forward "^[ \t]*#\\+begin_src.*$" nil t)
        (forward-line)
        (setq beg (point))
        (goto-char end)
        (re-search-backward "^[ \t]*#\\+end_src.*$" nil t)
        (forward-line -1)
        (end-of-line)
        (setq end (point)))
      (let ((code (buffer-substring-no-properties beg end))
            formattted-code)
        ;; (message "Region contents: %S" (buffer-substring-no-properties beg end))
        ;; Org indents src blocks two spaces
        (with-temp-buffer
          (setq fill-column original-fill-column)
          ;; Add one surrounding paren (required) and another (for indentation)
          (insert "((" code "))")
          (goto-char (point-min))
          (elisp-autofmt-region (point-min) (point-max))
          (setq formatted-code (buffer-string))
          ;; Remove the surrounding parentheses, add leading spaces for first line
          (setq formatted-code (concat "  " (substring formatted-code 2 -2))))
        ;; (message "Formatted code:\n%s" formatted-code))
        (save-excursion
          (goto-char beg)
          (delete-region beg end)
          (insert formatted-code)))
      (goto-char current-pos))))
