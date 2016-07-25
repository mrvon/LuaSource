// Package bank provides a concurrency-safe bank with one account.
package bank

type with_draw_req struct {
	amount int
	ret    chan bool
}

var deposits = make(chan int)            // send amount to deposit
var withdraws = make(chan with_draw_req) // send withdraw request
var balances = make(chan int)            // receive balance

func Deposit(amount int) {
	deposits <- amount
}

func Balance() int {
	return <-balances
}

func Withdraw(amount int) bool {
	r := with_draw_req{
		amount: amount,
		ret:    make(chan bool),
	}
	withdraws <- r
	return <-r.ret
}

func teller() {
	var balance int // balance is confined to teller goroutine

	for {
		select {
		case amount := <-deposits:
			balance += amount
		case balances <- balance:
			// Do nothing
		case wd := <-withdraws:
			if wd.amount > balance {
				wd.ret <- false
			} else {
				balance -= wd.amount
				wd.ret <- true
			}
		}
	}
}

func init() {
	go teller() // start the monitor goroutine
}
