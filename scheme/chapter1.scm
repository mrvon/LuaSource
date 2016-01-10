#lang scheme
; -----------------------------------------------------------------------------
; (+ 

;   (* 3
;      (+ (* 2 4)
;         (+ 3 5))
;      )

;   (+ (- 10 7)
;      6)

;   )

; (define size 2)

; size
; (* 5 size)

; -----------------------------------------------------------------------------
; (define pi 3.14159)
; (define radius 10)

; (* pi (* radius radius))

; (define circumference (* 2 pi radius))
; circumference

; -----------------------------------------------------------------------------
(define (square x)
  (* x x)
  )

(square 21)
(square (+ 2 5))
(square (square 3))

; -----------------------------------------------------------------------------
(define (sum-of-squares x y)
  (+ (square x) (square y))
  )

(sum-of-squares 3 4)

; -----------------------------------------------------------------------------
(define (f a)
  (sum-of-squares (+ a 1) (* a 2))
  )

(f 5)

; -----------------------------------------------------------------------------
(define (abs1 x)
  (cond ((> x 0) x)
        ((= x 0) 0)
        ((< x 0) (- x))
        )
  )

(define (abs2 x)
  (cond ((< x 0) (- x))
        (else x)
        )
  )

(define (abs3 x)
  (if (< x 0)
    (- x)
    x)
  )


(abs1 10)
(abs1 0)
(abs1 -10)

(abs2 10)
(abs2 0)
(abs2 -10)

(abs3 10)
(abs3 0)
(abs3 -10)

; -----------------------------------------------------------------------------
; Exercise 1.1
10
(+ 5 3 4)
(- 9 1)
(/ 6 2)
(+ (* 2 4) (- 4 6))
(define a 3)
(define b (+ a 1))
(+ a b (* a b))
(= a b)
(if (and (> b a) (< b (* a b)))
  b
  a
  )
(cond ((= a 4) 6)
      ((= b 4) (+ 6 7 a))
      (else 25)
      )
(+ 2
   (if (> b a)
     b
     a)
   )
(* 
  (cond 
    ((> a b) a)
    ((< a b) b)
    (else -1)
    )
  (+ a 1)
  )

; -----------------------------------------------------------------------------
; Exercise 1.2
(/
  (+ 5 
     4 (- 2
          (- 3
             (+ 6
                (/ 4 5))
             )
          )
     )
  (* 3
     (- 6 2)
     (- 2 7)
     )
  )

; -----------------------------------------------------------------------------
; Exercise 1.3
(define (max-sum a b c)
  (cond ((and (<= a b) (<= a c) (+ b c)))
        ((and (<= b a) (<= b c) (+ a c)))
        (else (+ a b))
        )
  )

(max-sum 1 2 3)
(max-sum 2 1 3)
(max-sum 3 1 2)

; -----------------------------------------------------------------------------
; Exercise 1.4
(define (a-plus-abs-b a b)
  (
   (if (> b 0) + -) 
   a
   b
   )
  )

(a-plus-abs-b 1 20)
(a-plus-abs-b 1 -20)

; -----------------------------------------------------------------------------
; Exercise 1.5
(define (p)
  (p)
  )

; endless loop
; (p)

(define (test x y)
  (if (= x 0)
    0
    y)
  )

; Error occur here!!!
; (test 0 (p))

; -----------------------------------------------------------------------------
(define (sqrt-iter guess x)
  (if (good-enough-func guess x)
    guess
    (sqrt-iter (improve guess x)
               x)
    )
  )

(define (improve guess x)
  (average guess (/ x guess))
  )

(define (average x y)
  (/ (+ x y) 2)
  )

(define (good-enough-func guess x)
  (good-enough_2 guess x)
  )

(define (good-enough_1 guess x)
  (< 
    (abs (- (square guess) x))
    0.001
    )
  )

(define (good-enough_2 guess x)
  (good-enough-templete improve guess x)
  )

(define (good-enough-templete improve-func guess x )
  (<
    (/
      (abs
        (-
          (improve-func guess x)
          guess
          )
        )
      guess
      )
    0.00000001
    )
  )

(define (sqrt x)
  (sqrt-iter 1.0 x)
  )

(sqrt 9)
(sqrt (+ 100 37))
(sqrt (+ (sqrt 2) (sqrt 3)))
(square (sqrt 1000))

; -----------------------------------------------------------------------------
; Exercise 1.6
(define (new-if predicate then-clause else-clause)
  (cond (predicate then-clause)
        (else else-clause))
  )

(define (new-sqrt-iter guess x)
  (new-if (good-enough-func guess x)
          guess
          (new-sqrt-iter (improve guess x)
                         x)
          )
  )

(define (new-sqrt x)
  (new-sqrt-iter 1.0 x)
  )

; endless loop
; (new-sqrt 3)

; -----------------------------------------------------------------------------
; Exercise 1.7
; grep good-enough_2

; -----------------------------------------------------------------------------
; Exercise 1.8
; Lexcial scoping
(define (improve-cube-root guess x)
(/
    (+ 
    (/ x (square guess))
    (* guess 2)
    )
    3)
)

(define (cube-root x)

  (define (cube-root-iter guess)
    (if (good-enough-cube guess)
      guess
      (cube-root-iter (improve-cube-root guess x))
      )
    )

  (define (good-enough-cube guess)
    (good-enough-templete improve-cube-root guess x)
    )

  (cube-root-iter 1.0)
  )

(cube-root 3)
(cube-root 4)
(cube-root 5)

; -----------------------------------------------------------------------------
(define (factorial n)
  (if (= n 1)
    1
    (* n (factorial (- n 1))))
  )

(factorial 5)
(factorial 6)
