#lang scheme
; -----------------------------------------------------------------------------
(+
  (* 3
     (+ (* 2 4)
        (+ 3 5))
     )
  (+ (- 10 7)
     6)
  )

(define size 2)

size
(* 5 size)

; -----------------------------------------------------------------------------
(define pi 3.14159)
(define radius 10)

(* pi (* radius radius))

(define circumference (* 2 pi radius))
circumference

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
(define (factorial_1 n)
  (if (= n 1)
    1
    (* n (factorial_1 (- n 1))))
  )

(factorial_1 5)
(factorial_1 6)

(define (factorial_2 max-count)
  (define (fact-iter product counter)
    (if (> counter max-count)
      product
      (fact-iter (* counter product)
                 (+ counter 1))
      )
    )

  (fact-iter 1 1)
  )

(factorial_2 5)
(factorial_2 6)

; -----------------------------------------------------------------------------
; Exercise 1.9

(define (inc x)
  (+ x 1)
  )

(define (dec x)
  (- x 1)
  )

(inc 0)
(dec 0)

(define (plus-1 a b)
  (if (= a 0)
    b
    (inc (plus-1 (dec a) b))
    )
  )

(plus-1 4 5)
(inc (plus-1 3 5))
(inc (inc (plus-1 2 5)))
(inc (inc (inc (plus-1 1 5))))
(inc (inc (inc (inc (plus-1 0 5)))))


(define (plus-2 a b)
  (if (= a 0)
    b
    (plus-2 (dec a) (inc b))
    )
  )

(plus-2 4 5)
(plus-2 3 6)
(plus-2 2 7)
(plus-2 1 8)
(plus-2 0 9)


; -----------------------------------------------------------------------------
; Exercise 1.10
(define (Ack x y)
  (cond ((= y 0) 0)
        ((= x 0) (* 2 y))
        ((= y 1) 2)
        (else (Ack
                (- x 1)
                (Ack x (- y 1))
                )
              )
        )
  )

; process
(Ack 1 10)
; -->
(Ack 0 (Ack 1 9))
(Ack 0 (Ack 0 (Ack 1 8)))
(Ack 0 (Ack 0 (Ack 0 (Ack 1 7))))
(Ack 0 (Ack 0 (Ack 0 (Ack 0 (Ack 1 6)))))
(Ack 0 (Ack 0 (Ack 0 (Ack 0 (Ack 0 (Ack 1 5))))))
(Ack 0 (Ack 0 (Ack 0 (Ack 0 (Ack 0 (Ack 0 (Ack 1 4)))))))
(Ack 0 (Ack 0 (Ack 0 (Ack 0 (Ack 0 (Ack 0 (Ack 0 (Ack 1 3))))))))
(Ack 0 (Ack 0 (Ack 0 (Ack 0 (Ack 0 (Ack 0 (Ack 0 (Ack 0 (Ack 1 2)))))))))
(Ack 0 (Ack 0 (Ack 0 (Ack 0 (Ack 0 (Ack 0 (Ack 0 (Ack 0 (Ack 0 (Ack 1 1))))))))))
(Ack 0 (Ack 0 (Ack 0 (Ack 0 (Ack 0 (Ack 0 (Ack 0 (Ack 0 (Ack 0 2)))))))))
(Ack 0 (Ack 0 (Ack 0 (Ack 0 (Ack 0 (Ack 0 (Ack 0 (Ack 0 4))))))))
(Ack 0 (Ack 0 (Ack 0 (Ack 0 (Ack 0 (Ack 0 (Ack 0 8)))))))
(Ack 0 (Ack 0 (Ack 0 (Ack 0 (Ack 0 (Ack 0 16))))))
(Ack 0 (Ack 0 (Ack 0 (Ack 0 (Ack 0 32)))))
(Ack 0 (Ack 0 (Ack 0 (Ack 0 64))))
(Ack 0 (Ack 0 (Ack 0 128)))
(Ack 0 (Ack 0 256))
(Ack 0 512)
; result
1024

; process
(Ack 2 4)
; -->
(Ack 1 (Ack 2 3))
(Ack 1 (Ack 1 (Ack 2 2)))
(Ack 1 (Ack 1 (Ack 1 (Ack 2 1))))
(Ack 1 (Ack 1 (Ack 1 2)))
(Ack 1 (Ack 1 (Ack 0 (Ack 1 1))))
(Ack 1 (Ack 1 (Ack 0 2)))
(Ack 1 (Ack 1 4))
(Ack 1 (Ack 0 (Ack 1 3)))
(Ack 1 (Ack 0 (Ack 0 (Ack 1 2))))
(Ack 1 (Ack 0 (Ack 0 (Ack 0 (Ack 1 1)))))
(Ack 1 (Ack 0 (Ack 0 (Ack 0 2))))
(Ack 1 (Ack 0 (Ack 0 4)))
(Ack 1 (Ack 0 8))
(Ack 1 16)
(Ack 0 (Ack 1 15))
(Ack 0 (Ack 0 (Ack 1 14)))
(Ack 0 (Ack 0 (Ack 0 (Ack 1 13))))
; ...

(Ack 3 3)


; -----------------------------------------------------------------------------
; Ack-f(n) = (Ack 0 n)
(define (Ack-f n)
  (Ack 0 n)
  )

; Ack-F(n) = 2*n
(define (Ack-F n)
  (* 2 n)
  )

(Ack-f 10)
(Ack-F 10)

; -----------------------------------------------------------------------------
; Ack-g(n) = (Ack 1 n)
(define (Ack-g n)
  (Ack 1 n)
  ; (Ack 0 (Ack 1 (- n 1)))     -- step 1
  ; (* 2 (Ack 1 (- n 1)))       -- step 2
  ; (* 2 (* 2 (Ack 1 (- n 2)))) -- step 3
  ; ...
  ; 2^n-1 (A 1 1)               -- step n-1
  ; 2^n                         -- step n
  )

(Ack-g 10)

; Ack-G(n) = 2^n
(define (Ack-G n)
  (cond ((= n 0) 1)
        ((= n 1) 2)
        (else (* 2
                 (Ack-G (- n 1)))
              )
        )
  )

(Ack-G 10)

; -----------------------------------------------------------------------------
; Ack-h(n) = (Ack 2 n)
; Ack-h(n) = 2^(Ack 2 n-1)
; Ack-h(n) = 2^2^(Ack 2 n-2)
; Ack-h(n) = 2^2^...2^(Ack 2 1)
; Ack-h(n) = 2^2^...2^2 (count of 2 is n)

(define (Ack-h n)
  (Ack 2 n)
  )

(Ack-h 4)

(define (Ack-H n)
  (if (> n 0)
    (Ack-G (Ack-H (- n 1)))
    1
    )
  )

(Ack-H 4)

; -----------------------------------------------------------------------------
(define (fib n)
  (cond ((= n 0) 0)
        ((= n 1) 1)
        (else (+ (fib (- n 1))
                 (fib (- n 2))
                 )
              )
        )
  )


(fib 0)
(fib 1)
(fib 2)
(fib 3)
(fib 4)
(fib 5)
(fib 6)
(fib 7)
(fib 8)

(define (fib-iter-version n)
  (fib-iter 1 0 n)
  )

(define (fib-iter a b count)
  (if (= count 0)
    b
    (fib-iter (+ a b) a (- count 1))
    )
  )

(fib-iter-version 0)
(fib-iter-version 1)
(fib-iter-version 2)
(fib-iter-version 3)
(fib-iter-version 4)
(fib-iter-version 5)
(fib-iter-version 6)
(fib-iter-version 7)
(fib-iter-version 8)

; -----------------------------------------------------------------------------
(define (count-change amount)

  (define (cc amount kind-of-coins)
    (cond ((= amount 0) 1)
          ((or (< amount 0) (= kind-of-coins 0)) 0)
          (else (+ (cc amount (- kind-of-coins 1))
                   (cc (- amount (first-denomination kind-of-coins)) kind-of-coins)
                   )
                )
          )
    )

  (define (first-denomination kind-of-coins)
    (cond ((= kind-of-coins 1) 1)
          ((= kind-of-coins 2) 5)
          ((= kind-of-coins 3) 10)
          ((= kind-of-coins 4) 25)
          ((= kind-of-coins 5) 50)
          )
    )

  (cc amount 5)
  )

(count-change 100)

; -----------------------------------------------------------------------------
; Exercise 1.11

(define (func_11 n)
  (if (< n 3)
    n
    (+
      (func_11 (- n 1))
      (* 2 (func_11 (- n 2)))
      (* 3 (func_11 (- n 3)))
      )
    )
  )

(func_11 0)
(func_11 1)
(func_11 2)
(func_11 3)
(func_11 4)
(func_11 5)
(func_11 6)
(func_11 7)
(func_11 8)
(func_11 9)


(define (func_11-inter-version n)
  (define (func_11-inter x1 x2 x3 n)
    (if (>= n 0)
      (func_11-inter x2 x3 (+ x3 (* 2 x2) (* 3 x1)) (- n 1))
      x3
      )
    )

  (cond ((<= n 0) 0)
        ((= n 1) 1)
        ((= n 2) 2)
        (else
          (func_11-inter 0 1 2 (- n 3))
          )
        )
  )

(func_11-inter-version 0)
(func_11-inter-version 1)
(func_11-inter-version 2)
(func_11-inter-version 3)
(func_11-inter-version 4)
(func_11-inter-version 5)
(func_11-inter-version 6)
(func_11-inter-version 7)
(func_11-inter-version 8)
(func_11-inter-version 9)

; -----------------------------------------------------------------------------
; Exercise 1.12
; FIXME
(define (pascal-triangle n)
  (cond ((= n 1) 1)
        ((= n 2) 1)
    )
  )

(pascal-triangle 2)


; -----------------------------------------------------------------------------
; Exercise 1.13
(fib-iter-version 0)
(fib-iter-version 1)
(fib-iter-version 2)
(fib-iter-version 3)

; -----------------------------------------------------------------------------
; Exercise 1.14
;log(x)
(count-change 11)

; -----------------------------------------------------------------------------
; Exercise 1.15

(define (sine angle)

  (define (cube x)
    (* x x x)
    )

  (define (p x)
    (- (* 3 x)
       (* 4 (cube x))
       )
    )

  (if (not (> (abs angle) 0.1))
    angle
    (p (sine (/ angle 3.0)))
    )
  )

(sine 12.15)

; -----------------------------------------------------------------------------
(define (expt b n)
  (if (= n 0)
    1
    (* b (expt b (- n 1)))
    )
  )

(expt 2 0)
(expt 2 1)
(expt 2 2)
(expt 2 3)
(expt 2 4)
(expt 2 5)
(expt 2 6)
(expt 2 7)
(expt 2 8)


(define (expt-iter-version b n)

  (define (expt-iter b counter product)
    (if (= counter 0)
      product
      (expt-iter b (- counter 1) (* product b))
      )
    )

  (expt-iter b n 1)
  )

(expt-iter-version 2 0)
(expt-iter-version 2 1)
(expt-iter-version 2 2)
(expt-iter-version 2 3)
(expt-iter-version 2 4)
(expt-iter-version 2 5)
(expt-iter-version 2 6)
(expt-iter-version 2 7)
(expt-iter-version 2 8)

; -----------------------------------------------------------------------------
; Exercise 1.16
(define (fast-expt b n)

  (define (is-even counter)
    (= (remainder counter 2) 0)
    )

  (define (expt-iter b counter product)
    (cond ((= counter 0) product)
          ((is-even counter) (expt-iter b (- counter 2) (* product b b)))
          (else (expt-iter b (- counter 1) (* product b)))
      )
    )

  (expt-iter b n 1)
  )

(fast-expt 2 0)
(fast-expt 2 1)
(fast-expt 2 2)
(fast-expt 2 3)
(fast-expt 2 4)
(fast-expt 2 5)
(fast-expt 2 6)
(fast-expt 2 7)
(fast-expt 2 8)


; -----------------------------------------------------------------------------
; Exercise 1.17
(define (multi-1 a b)
  (if (= b 0)
    0
    (+ a (multi-1 a (- b 1)))
   )
  )


(multi-1 32 32)


(define (multi-2 a b)

  (define (double n)
    (+ n n)
    )

  (define (halve n)
    (/ n 2)
    )

  (define (is-even n)
    (= (remainder n 2) 0)
    )

  (cond ((= b 0) 0)
        ((is-even b) (+ (double a) (multi-2 a (- b 2))))
        (else (+ a (multi-2 a (- b 1)))
          )
        )
  )


(multi-2 32 32)
