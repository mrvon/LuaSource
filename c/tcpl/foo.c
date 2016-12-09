#include <stdio.h>
#include <string.h>

#define IN  1
#define OUT 2
#define MAXLINE 1000

int get_line(char line[], int max_line)
{
    int c = 0;
    int i = 0;

    for (i = 0; i < max_line - 1 && (c = getchar()) != EOF && c != '\n'; i++) {
        line[i] = c;
    }
    if (c == '\n') {
        line[i] = c;
        ++i;
    }
    line[i] = '\0';
    return i;
}

void copy(char to[], char from[])
{
    int i = 0;
    while ((to[i] = from[i]) != '\0') {
        ++i;
    }
}

void reverse(char s[])
{
    int i;
    int j;
    char temp;

    for (i = 0, j = strlen(s) - 1; i < j; ++i, --j)
    {
        temp = s[i];
        s[i] = s[j];
        s[j] = temp;
    }
}

char ntoc(int i)
{
    if (i >= 0 && i <= 9) {
        return i + '0';
    }
    else if (i >= 10 && i <= 16) {
        return i - 10 + 'a';
    }
    return '_';
}

void itob_ex(int n, char s[], int b, int w)
{
    int i;
    int sign;
    int l;

    if ((sign = n) < 0)
        n = -n;
    i = 0;

    do {
        s[i++] = ntoc(n % b);
    }while ((n /= b) > 0);

    if (sign < 0)
        s[i++] = '-';

    l = strlen(s);
    if (w > l) {
        w = w - l;
    }
    else {
        w = 0;
    }

    while(w--) {
        s[i++] = ' ';
    }

    s[i] = '\0';

    reverse(s);
}

void itoa_ex(int n, char s[], int w)
{
    itob_ex(n, s, 10, w);
}

void itoa(int n, char s[])
{
    itoa_ex(n, s, 0);
}

int trim(char s[])
{
    int n;

    for (n = strlen(s) - 1; n >= 0; n--) {
        if (s[n] != ' ' && s[n] != '\n' && s[n] != '\t') {
            break;
        }
    }
    s[n + 1] = '\0';
    return n;
}

void kr_strcat(char* s, char* t)
{
    while (*s != '\0')
        ++s;
    while ((*s++ = *t++) != '\0')
        ;
}

int kr_strend(char* s, char* t)
{
    int slen = strlen(s) - 1;
    int tlen = strlen(t) - 1;
    if (slen < tlen) {
        return 0;
    }

    while(slen >= 0 && tlen >= 0) {
        if (*(s + slen) != *(t + tlen))
            return 0;
        --slen;
        --tlen;
    }

    return 1;
}

int main(int argc, char const* argv[])
{
/*
 * #define db_kr_strend(s, t) printf("%s %s: %d\n", s, t, kr_strend(s, t))
 * 
 *     db_kr_strend("hello", "h");
 *     db_kr_strend("hello", "o");
 *     db_kr_strend("hello", "lo");
 *     db_kr_strend("hello", "ol");
 *     db_kr_strend("hello", "llo");
 *     db_kr_strend("hello", "ello");
 *     db_kr_strend("hello", "hello");
 *     db_kr_strend("hello", "ahello");
 */


/*
 *     char hello_world[1024] = "hello";
 * 
 *     kr_strcat(hello_world, " world");
 * 
 *     printf("%s\n", hello_world);
 */

/*
 *     int i;
 *     int w = 0;
 *     char a[1024];
 * 
 *     i = 0x7FFFFFFF + 1;
 * 
 *     itoa(i, a);
 *     printf("%d -> %s\n", i, a);
 * 
 *     itoa_ex(i, a, w);
 *     printf("%d -> %s\n", i, a);
 * 
 *     itob_ex(i, a, 8, w);
 *     printf("%d -> %s\n", i, a);
 * 
 *     itob_ex(i, a, 2, w);
 *     printf("%d -> %s\n", i, a);
 * 
 *     i = 255;
 *     itob_ex(i, a, 16, w);
 *     printf("%d -> %s\n", i, a);
 */

/*
 *     int i;
 *     int unsorted_arr[] = {9, 2, 3, 4, 5, 6, 1, 8, 0, 7};
 *     int n = sizeof(unsorted_arr) / sizeof(int);
 * 
 *     printf("BEFORE SORT: ");
 *     for (i = 0; i < n; i++) {
 *         printf("%d ", unsorted_arr[i]);
 *     }
 *     printf("\n");
 * 
 *     __shellsort(unsorted_arr, n);
 * 
 *     printf("AFTER SORT: ");
 *     for (i = 0; i < n; i++) {
 *         printf("%d ", unsorted_arr[i]);
 *     }
 *     printf("\n");
 */

/*
 *     printf("%X \tBIT: %d\n", 0x1, bitcount(0x1));
 *     printf("%X \tBIT: %d\n", 0xF, bitcount(0xF));
 *     printf("%X \tBIT: %d\n", 0x1F, bitcount(0x1F));
 * 
 *     printf("%X \tBIT: %d\n", 0x1, fastbitcount(0x1));
 *     printf("%X \tBIT: %d\n", 0xF, fastbitcount(0xF));
 *     printf("%X \tBIT: %d\n", 0x1F, fastbitcount(0x1F));
 */

/*
 *     int len = 0;
 *     int max = 0;
 *     char line[MAXLINE];
 *     char longest[MAXLINE];
 * 
 *     while ((len = get_line(line, MAXLINE)) > 0) {
 *         if (len > max) {
 *             max = len;
 *             copy(longest, line);
 *         }
 *     }
 *     if (max > 0) {
 *         printf("%s", longest);
 *     }
 * 
 *     return 0;
 */

/*
 *     int c = 0;
 *     int i = 0;
 *     int nwhite = 0;
 *     int nother = 0;
 *     int ndigit[10];
 * 
 *     for (i = 0; i < 10; i++) {
 *         ndigit[i] = 0;
 *     }
 * 
 *     while ((c = getchar()) != EOF) {
 *         if (c >= '0' && c <= '9') {
 *             ++ndigit[c - '0'];
 *         }
 *         else if (c == ' ' || c == '\n' || c == '\t') {
 *             ++nwhite;
 *         }
 *         else {
 *             ++nother;
 *         }
 *     }
 * 
 *     printf("digits = ");
 *     for (i = 0; i < 10; i++) {
 *         printf(" %d", ndigit[i]);
 *     }
 *     printf(", white space = %d, other = %d\n", nwhite, nother);
 */

/*
 *     int c = 0;
 *     int state = OUT;
 * 
 *     while ((c = getchar()) != EOF) {
 *         if (c == ' ' || c == '\n' || c == '\t') {
 *             if (state == IN) {
 *                 state = OUT;
 *                 putchar('\n');
 *             }
 *         }
 *         else {
 *             state = IN;
 *             putchar(c);
 *         }
 *     }
 */

/*
 *     int c = 0;
 *     int nc = 0;
 *     int nl = 0;
 *     int nw = 0;
 *     int state = OUT;
 * 
 *     while ((c = getchar()) != EOF) {
 *         ++nc;
 *         if (c == '\n') {
 *             ++nl;
 *         }
 *         if (c == ' ' || c == '\n' || c == '\t') {
 *             state = OUT;
 *         }
 *         else if (state == OUT) {
 *             state = IN;
 *             ++nw;
 *         }
 *     }
 *     printf("%d %d %d\n", nl, nw, nc);
 *     
 *     return 0;
 */
}
