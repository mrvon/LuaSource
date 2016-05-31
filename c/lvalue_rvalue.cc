#include <iostream>
#include <string>

/*
    The distinction between lvalues (what can be used on the left-hand side of 
    an assignment) and rvalues (what can be used on the right-hand side of an assignment) 
    goes back to Christopher Strachey (the father of C++'s distant ancestor CPL and 
    of denotational semantics). In C++, non-const references can bind to lvalues 
    and const references can bind to lvalues or rvalues, but there is nothing that 
    can bind to a non-const rvalue. 
*/

std::string foo() {
    return "hello";
}

int main(int argc, char const* argv[]) {
    std::string a;

    std::string &r1 = a;                // bind r1 to a (an lvalue)
    // std::string &r2 = foo();         // error: f() is an rvalue: can't bind
    const std::string &cr1 = foo();     // const reference is ok
    
    std::string &&rr1 = foo();          // find: bind rr1 to temporary
    // std::string &&rr2 = a;           // error: bind a is an lvalue

    return 0;
}
