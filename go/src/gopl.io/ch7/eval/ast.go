package eval

// An Expr is an arithmetic expression
type Expr interface {
	Eval(env Env) float64
	Check(vars map[Var]bool) error
}

// A Var identifies a variable
type Var string

// A literal is a numeric constant
type literal float64

// A unary represents a unary operator expression
type unary struct {
	op rune // one of '+', '-'
	x  Expr
}

// A binary represents a binary operator expression
type binary struct {
	op rune // one of '+', '-', '*', '/'
	x  Expr
	y  Expr
}

// A call represents a function call expression
type call struct {
	fn   string // one of "pow", "sin", "sqrt"
	args []Expr
}
