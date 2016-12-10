/*
Reservoir reservoir_sampling

https://en.wikipedia.org/wiki/Reservoir_sampling

Example: sample size 1

Suppose we see a sequence of items, one at a time. We
want to keep a single item in memory, and we want it to be selected at random
from the sequence. If we know the total number of items (n), then the solution
is easy: select an index i between 1 and n with equal probability, and keep the
i-th element. The problem is that we do not always know n in advance. A possible
solution is the following:

Keep the first item in memory.
When the i-th item arrives (for i>1):
with probability 1/i, keep the new item (discard the old one)
with probability {\displaystyle 1-1/i}, keep the old item (ignore the new one)
So:

when there is only one item, it is kept with probability 1;
when there are 2 items, each of them is kept with probability 1/2;
when there are 3 items, the third item is kept with probability 1/3, and each of
the previous 2 items is also kept with probability (1/2)(1-1/3) = (1/2)(2/3) =
1/3; by induction, it is easy to prove that when there are n items, each item is
kept with probability 1/n.
*/

package main

import (
	"fmt"
	"math/rand"
)

func reservoir_sampling(nums []int) int {
	n := nums[0]

	for i := 1; i < len(nums); i++ {
		r := rand.Int() % (i + 1)
		if r >= i {
			n = nums[i]
		}
	}
	return n
}

func main() {
	nums := []int{1, 2, 3, 4, 5, 6, 7, 8, 9}

	fmt.Println(reservoir_sampling(nums))
	fmt.Println(reservoir_sampling(nums))
	fmt.Println(reservoir_sampling(nums))
	fmt.Println(reservoir_sampling(nums))
	fmt.Println(reservoir_sampling(nums))
	fmt.Println(reservoir_sampling(nums))
	fmt.Println(reservoir_sampling(nums))
	fmt.Println(reservoir_sampling(nums))
	fmt.Println(reservoir_sampling(nums))
	fmt.Println(reservoir_sampling(nums))
	fmt.Println(reservoir_sampling(nums))
}
