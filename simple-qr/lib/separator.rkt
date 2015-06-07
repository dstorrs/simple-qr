#lang racket

(require "func.rkt")

(provide (contract-out
          [draw-separator (-> any/c
                              exact-nonnegative-integer?
                              exact-nonnegative-integer?
                              void?)]
          ))

(define *separator_points*
  '(
    (                                                        (1 . 8)
                                                             (2 . 8)
                                                             (3 . 8)
                                                             (4 . 8)
                                                             (5 . 8)
                                                             (6 . 8)
                                                             (7 . 8)
     (8 . 1) (8 . 2) (8 . 3) (8 . 4) (8 . 5) (8 . 6) (8 . 7) (8 . 8))
    ((1 . 1) (1 . 2) (1 . 3) (1 . 4) (1 . 5) (1 . 6) (1 . 7) (1 . 8)
                                                             (2 . 8)
                                                             (3 . 8)
                                                             (4 . 8)
                                                             (5 . 8)
                                                             (6 . 8)
                                                             (7 . 8)
                                                             (8 . 8))
    ((1 . 1) 
     (2 . 1)
     (3 . 1)
     (4 . 1)
     (5 . 1)
     (6 . 1)
     (7 . 1)
     (8 . 1) (8 . 2) (8 . 3) (8 . 4) (8 . 5) (8 . 6) (8 . 7) (8 . 8))))

(define (draw-separator dc modules module_width)
  (let* ([finder_pattern_start_points (locate-finder-pattern modules)]
         [top_left_point (first finder_pattern_start_points)]
         [top_right_point (second finder_pattern_start_points)]
         [bottom_left_point (third finder_pattern_start_points)]
         [new_top_right_point (cons (sub1 (car top_right_point)) (cdr top_right_point))]
         [new_bottom_point (cons (car bottom_left_point) (sub1 (cdr bottom_left_point)))])
    (for-each
     (lambda (point_pair)
       (draw-module dc "white" (locate-brick module_width point_pair) module_width))
     (transform-points-list (first *separator_points*) top_left_point))

     (for-each
      (lambda (point_pair)
        (draw-module dc "white" (locate-brick module_width point_pair) module_width))
      (transform-points-list (second *separator_points*) new_top_right_point))

     (for-each
      (lambda (point_pair)
        (draw-module dc "white" (locate-brick module_width point_pair) module_width))
      (transform-points-list (third *separator_points*) new_bottom_point))))
