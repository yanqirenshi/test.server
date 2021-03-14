(in-package :test.server)

(defun make-response-header (type)
  (list :content-type (if (eq :json type)
                          "application/json"
                          "text/plain")
        :access-control-allow-origin "*"))

(defun make-response-body (type contents)
  (list (if (eq :json type)
            (jojo:to-json contents)
            contents)))

(defmacro response (&key (type :json) (code 200) (body nil))
  `(handler-case
       (list ,code
             (make-response-header ,type)
             (make-response-body   ,type ,body))
     (error ()
       (list 500
             (make-response-header ,type)
             "Server Error"))))
