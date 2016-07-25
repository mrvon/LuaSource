package bank_test

import (
	"fmt"
	"testing"

	"gopl.io/ch9/bank4"
)

func TestBank(t *testing.T) {
	done := make(chan struct{})

	// Alice
	go func() {
		bank.Deposit(200)
		fmt.Println("=", bank.Balance())
		done <- struct{}{}
	}()

	// Bob
	go func() {
		bank.Deposit(100)
		ok := bank.Withdraw(50)
		fmt.Printf("Withdraw 50: %v\n", ok)
		done <- struct{}{}
	}()

	// Wait for both transactions.
	<-done
	<-done

	if got, want := bank.Balance(), 250; got != want {
		t.Errorf("Balance = %d, want %d", got, want)
	}
}
