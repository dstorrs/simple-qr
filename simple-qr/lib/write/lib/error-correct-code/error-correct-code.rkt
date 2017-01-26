#lang racket

(provide (contract-out 
          [error-code (-> list? exact-nonnegative-integer? string? list?)]
          [to-message-poly (-> list? string?)]
          ))

(require "../func/code-log/code-log-func.rkt")
(require "../func/code-info/code-info-func.rkt")
(require "../func/poly/poly-dic-func.rkt")
(require "../func/func.rkt")
(require "poly-func.rkt")

(define (to-message-poly number_list)
  (with-output-to-string
    (lambda ()
      (let loop ([loop_list number_list])
        (when (not (null? loop_list))
              (printf "~ax~a" (car loop_list) (sub1 (length loop_list)))
              (when (> (length loop_list) 1)
                    (printf "+"))
              (loop (cdr loop_list)))))))

(define (error-code number_list version error_level)
  (let ([ec_count #f]
        [origin_poly_message #f]
        [origin_poly_generator #f]
        [poly_message #f]
        [poly_message_count #f]
        [poly_generator #f]
        )

    (trace (format "error-code step by step\n") 3)

    (trace (format "source=[~a]\n" number_list) 3)

    (set! ec_count (get-ec-count version error_level))
    (trace (format "st1: version=[~a] error_level=[~a] ec_count=[~a]\n" version error_level ec_count) 3)

    (set! origin_poly_message (to-message-poly number_list))
    (trace (format "st2: origin_poly_message=[~a]\n" origin_poly_message) 3)

    (set! origin_poly_generator (get-poly ec_count))
    (trace (format "st3: origin_poly_generator=[~a]\n" origin_poly_generator) 3)

    (set! poly_message (message-multiply-x origin_poly_message ec_count))
    (set! poly_message_count (length (regexp-split #rx"\\+" poly_message)))
    (trace (format "st4: poly_message=[~a] poly_message_count=[~a]\n" poly_message poly_message_count) 3)
    
    (set! poly_generator (poly-align-on-x origin_poly_generator poly_message))
    (trace (format "st5: poly_generator=[~a]\n" poly_generator) 3)
    
    (let loop ([loop_poly_generator poly_generator]
               [loop_poly_message poly_message]
               [count 1])
      (if (<= count poly_message_count)
          (begin
            (trace (format "step:~a-1 message=[~a] generator=[~a]\n" count loop_poly_message loop_poly_generator) 3)
            
            (let ([loop_poly_generator_aligned_a #f]
                  [loop_poly_generator_aligned_v #f])
                  
              (if (regexp-match #rx"^0x.*" loop_poly_message)
                  (set! loop_poly_generator_aligned_v (poly-to-zero loop_poly_generator))
                  (begin
                    (set! loop_poly_generator_aligned_a (poly-align-on-a loop_poly_generator loop_poly_message))
                    (trace (format "step:~a-2 loop_poly_generator_aligned_a=~a\n" count loop_poly_generator_aligned_a) 3)
              
                    (set! loop_poly_generator_aligned_v (poly-a-to-v loop_poly_generator_aligned_a))
                    (trace (format "step:~a-3 loop_poly_generator_aligned_v=~a\n" count loop_poly_generator_aligned_v) 3)))

              (let-values ([(skip_count loop_poly_message_result_v)
                            (poly-xor loop_poly_message loop_poly_generator_aligned_v)])
                (trace (format "step:~a-4 skip_count=[~a]loop_poly_message_xor_result_v=~a\n" count skip_count loop_poly_message_result_v) 3)

                (loop (poly-multiply-x loop_poly_generator (* skip_count -1)) loop_poly_message_result_v (+ count skip_count)))))
          (poly-get-codeword loop_poly_message)))))