(in-package :test.server)

(defun ensure-port (port)
  (parse-integer (or port "8080")))

(defun ensure-address (address)
  (or address "0.0.0.0"))

(defun start-server ()
  (setf *svr*
        (clack:clackup (lack:builder (:static :path "/public/" :root #P"/static-files/")
                                     *router*)
                       :server  :hunchentoot
                       :port    (ensure-port    (uiop:getenv "PORT"))
                       :address (ensure-address (uiop:getenv "ADDRESS")))))

(defun gc-loop ()
  (do ((counter 0 (1+ counter))
       (gc-point 88888888))
      (*balus* (clack:stop *svr*))
    (sleep 1)
    (when (= counter gc-point)
      (setf counter 0)
      (sb-ext:gc))))


(defun start ()
  (start-server)
  (gc-loop))
