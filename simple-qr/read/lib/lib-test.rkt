#lang racket

(require rackunit/text-ui)

(require rackunit "lib.rkt")

(require racket/runtime-path)
(define-runtime-path test_file "test.png")

(define test-lib
  (test-suite 
   "test-lib"
   
   ;module_width is 5

   (test-case
    "tests"

    (let ([points_list (pic->points test_file)])
      (check-equal? (length points_list) 165)
      (check-equal? (length (car points_list)) 165)

      (check-equal? (list-ref (list-ref points_list 0) 0) 765)
      (check-equal? (list-ref (list-ref points_list 0) 164) 765)

      (check-equal? (list-ref (list-ref points_list 30) 0) 765)
      (check-equal? (list-ref (list-ref points_list 30) 5) 765)
      (check-equal? (list-ref (list-ref points_list 30) 10) 765)
      (check-equal? (list-ref (list-ref points_list 30) 15) 765)
      (check-equal? (list-ref (list-ref points_list 30) 20) 0)
      (check-equal? (list-ref (list-ref points_list 30) 25) 765)
      (check-equal? (list-ref (list-ref points_list 30) 30) 0)
      (check-equal? (list-ref (list-ref points_list 30) 35) 0)
      (check-equal? (list-ref (list-ref points_list 30) 40) 0)
      (check-equal? (list-ref (list-ref points_list 30) 45) 765)
      (check-equal? (list-ref (list-ref points_list 30) 50) 0)
      (check-equal? (list-ref (list-ref points_list 30) 55) 765)
      
      (check-equal? (find-threshold points_list) 382)
    ))
   
   (test-case
    "test-points->bw"
    
    (let* ([points '((100 1 80 10) (200 1 300 10))]
           [bw_points (points->bw points 50)])

      (check-equal? (list-ref (list-ref bw_points 0) 0) 0)
      (check-equal? (list-ref (list-ref bw_points 0) 1) 1)
      (check-equal? (list-ref (list-ref bw_points 0) 2) 0)
      (check-equal? (list-ref (list-ref bw_points 0) 3) 1)

      (check-equal? (list-ref (list-ref bw_points 1) 0) 0)
      (check-equal? (list-ref (list-ref bw_points 1) 1) 1)
      (check-equal? (list-ref (list-ref bw_points 1) 2) 0)
      (check-equal? (list-ref (list-ref bw_points 1) 3) 1)
      ))

   ))

(run-tests test-lib)