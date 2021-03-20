(in-package :test.server)

(defun ensure-port (port)
  (parse-integer (or port "8080")))

(defun ensure-address (address)
  (or address "0.0.0.0"))

(defun basic-auth (user pass)
  (and (string= user "hoge")
       (string= pass "fuga")))

(defvar *mw*
  (lambda (app)
    (lambda (env)
      ;; preprocessing
      (let ((res (funcall app env)))
        ;; postprocessing
        res))))

(defun build ()
  (lack:builder :session
                *mw*
                (:auth-basic :authenticator #'basic-auth)
                (:static :path "/public/" :root #P"/static-files/")
                *router*))

(defun start-server ()
  (setf *svr*
        (clack:clackup (build)
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

;;;;;
;;;;;
;;;;;
(defun basic-auth (user pass)
  (and (string= user "hoge")
       (string= pass "fuga")))

(defun return-401 (realm)
  `(401
    (:content-type "text/plain"
     :content-length 22
     :www-authenticate ,(format nil "Basic realm=~A" realm))
    ("Authorization required")))

(defun parse-authorization-header (authorization)
  (when (string= authorization "Basic " :end1 6)
    (let ((user-and-pass (cl-base64:base64-string-to-string (subseq authorization 6))))
      (split-sequence:split-sequence #\: user-and-pass))))

(defvar *middleware-auth-basic*
  (lambda (app)
    (lambda (env)
      (block nil
        (let ((realm "restricted area")
              (authorization (gethash "authorization" (getf env :headers))))
          (unless authorization
            (return (return-401 realm)))
          (destructuring-bind (user &optional (pass ""))
              (parse-authorization-header authorization)
            (if user
                (multiple-value-bind (result returned-user)
                    (funcall #'basic-auth user pass)
                  (if result
                      (progn
                        (setf (getf env :remote-user)
                              (or returned-user user))
                        (funcall app env))
                      (return-401 realm)))
                (return-401 realm))))))))
