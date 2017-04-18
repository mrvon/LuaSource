int main() {
    int a = 0;
    int b = 0;
    int c = 0;
    int d = 0;

    if (a == b)
        if (c == d)
            a = d;
    else
        a = c;


    /* dangling else problem 
     
       the program above is same as:

        if (a == b) {
            if (c == d) {
                a = d;
            }
            else {
                a = c;
            }
        }

        In the clang compiler, it will have warning following:

        dangling_else.c:10:5: warning: add explicit braces to avoid dangling else
            [-Wdangling-else]
            else
            ^
        1 warning generated.
     */
}
