#lang racket

(require racket/draw)

(require "lib/func.rkt")
(require "lib/finder-pattern.rkt")
(require "lib/separator.rkt")

(let* ([version 5]
       [modules (version->modules version)]
       [module_width 10]
       [canvas_width (* modules module_width)]
       )

  (define target (make-bitmap canvas_width canvas_width))

  (define dc (new bitmap-dc% [bitmap target]))
  (send dc set-smoothing 'smoothed)

  ;; draw the background, help to count module
  (let loop-row ([row 1])
    (when (<= row modules)
          (let loop-col ([col 1])
            (when (<= col modules)
                  (if (= (remainder col 2) 1)
                      (draw-module dc "pink" (locate-brick module_width (cons row col)) module_width)
                      (draw-module dc "orchid" (locate-brick module_width (cons row col)) module_width))
                  (loop-col (add1 col))))

          (let loop-col ([col 1])
            (when (<= col modules)
                  (when (= (remainder row 2) 0)
                        (draw-module dc "orchid" (locate-brick module_width (cons row col)) module_width))
                  (loop-col (add1 col))))
                  
            (loop-row (add1 row))))
    

  (draw-finder-pattern dc modules module_width)

  (draw-separator dc modules module_width)  

  (send target save-file "box.png" 'png)

  (system "open box.png")
)