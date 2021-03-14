(in-package :test.server)


(defun get-genius (&key gcp-user-id gcp-user-email ensure)
  (assert gcp-user-id)
  (assert gcp-user-email)
  (let ((deccot (gp-iap.get :id gcp-user-id)))
    (if (not deccot)
        (when ensure
          (make-deccot-and-genius gcp-user-id))
        (let ((genius (genius.get :deccot deccot)))
          (or genius
              (when ensure
                (make-genius-at-deccot deccot)))))))


(defun balus ()
  (setf *balus* t)
  "Good by!")
