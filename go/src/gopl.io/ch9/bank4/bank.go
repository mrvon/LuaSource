package bank

import "sync"

var (
	mu      sync.RWMutex // guards balance
	balance int
)

func Deposit(amount int) {
	mu.Lock() // writer lock
	balance = balance + amount
	mu.Unlock()
}

func Balance() int {
	mu.RLock() // readers lock
	defer mu.RUnlock()
	return balance
}

func Withdraw(amount int) bool {
	mu.Lock()
	defer mu.Unlock()
	if amount > balance {
		return false
	} else {
		balance = balance - amount
		return true
	}
}
