package bank

var (
	sema    = make(chan struct{}, 1) // a binary semaphore guarding balance
	balance int
)

func Deposit(amount int) {
	sema <- struct{}{} // acquire token
	balance = balance + amount
	<-sema // release token
}

func Balance() int {
	sema <- struct{}{} // acquire token
	b := balance
	<-sema // release token
	return b
}

func Withdraw(amount int) bool {
	sema <- struct{}{} // acquire token
	if amount > balance {
		<-sema // release token
		return false
	} else {
		balance = balance - amount
		<-sema // release token
		return true
	}
}
