(in-package :test.server)

(defvar *router* (make-instance 'ningle:<app>))

(defun val (key params)
  (cdr (if (stringp key)
           (assoc key params :test 'string=)
           (assoc key params))))

;; (setf (ningle:route *router* "/deccots/:id/genius")
;;       #'(lambda (params)
;;           (let ((deccot-id (val :id      params))
;;                 (ensure    (val "ensure" params)))
;;             (response :body (get-genius-by-deccot-id deccot-id :ensure ensure)))))

(setf (ningle:route *router* "/")
      "Welcome to Genius Party!")

(setf (ningle:route *router* "/readiness_check")
      "Liveness Check OK!!")

(setf (ningle:route *router* "/liveness_check")
      "Liveness Check OK!!")

(setf (ningle:route *router* "/balus")
      #'(lambda (params)
          (declare (ignore params))
          (response :body (balus) :code 201)))
