#include <stdio.h>
#include <string.h>

int main() {
    char tmp[] = "one two\nthree\r\n\tfour";
    char* args = tmp;

    char* n = strsep(&args, " \t\r\n");
    printf("%s\n", n);

    n = strsep(&args, " \t\r\n");
    printf("%s\n", n);

    n = strsep(&args, " \t\r\n");
    printf("%s\n", n);

    n = strsep(&args, " \t\r\n");
    printf("%s\n", n);
}
