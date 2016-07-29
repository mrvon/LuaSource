package format_test

import (
	"fmt"
	"testing"
	"time"

	"gopl.io/ch12/format"
)

func Test(t *testing.T) {
	// The pointer values are just examples, and may vary from run to run.
	var x int64 = 1
	var f float32 = 3.141592653589793238463643383279
	var lf float64 = 3.141592653589793238463643383279
	var d time.Duration = 1 * time.Nanosecond

	fmt.Println(format.Any(nil))
	fmt.Println(format.Any(x))
	fmt.Println(format.Any(f))
	fmt.Println(format.Any(lf))
	fmt.Println(format.Any(d))
	fmt.Println(format.Any([]int64{x}))
	fmt.Println(format.Any([]time.Duration{d}))
}
