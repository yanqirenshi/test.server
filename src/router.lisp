(in-package :test.server)

(defvar *router* (make-instance 'ningle:<app>))

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
