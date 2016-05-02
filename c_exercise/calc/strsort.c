#include <stdio.h>
#include <string.h>
#include "calc.h"

#define MAXLINES 5000
char* lineptr[MAXLINES];

int readlines(char* lineptr[], int nlines);
void writelines(char* lineptr[], int nlines);
void str_qsort(void* v[], int left, int right,
        int (*comp)(void*, void*));

int main(int argc, char const* argv[])
{
    int nlines;

    int (*rl)(char* lineptr[], int nlines) = readlines;
    void (*wl)(char* lineptr[], int nlines) = writelines;

    if ((nlines = (*rl)(lineptr, MAXLINES)) >= 0) {
        str_qsort((void**)lineptr, 0, nlines - 1, (int(*)(void*, void*))strcmp);
        (*wl)(lineptr, nlines);
        return 0;
    }
    else {
        printf("error: input too big to sort\n");
        return 1;
    }

    return 0;
}

#define MAXLINE 1000
int kr_getline(char*, int);
char* alloc(int);

int readlines(char* lineptr[], int maxlines)
{
    int len;
    int nlines;
    char* p;
    char line[MAXLINE];

    nlines = 0;

    while ((len = kr_getline(line, MAXLINE)) > 0) {
        if (nlines >= maxlines || (p = alloc(len)) == NULL) {
            return -1;
        }
        else {
            line[len - 1] = '\0';
            strcpy(p, line);
            lineptr[nlines++] = p;
        }
    }
    return nlines;
}

void writelines(char* lineptr[], int nlines)
{
    int i;

    for (i = 0; i < nlines; ++i) {
        printf("%s\n", lineptr[i]);
    }
}

void str_swap(void* v[], int i, int j)
{
    void* temp;

    temp = v[i];
    v[i] = v[j];
    v[j] = temp;
}

void str_qsort(void* v[], int left, int right,
        int (*comp)(void*, void*))
{
    int i;
    int last;

    if (left >= right)
        return;

    str_swap(v, left, (left + right) / 2);
    last = left;
    for (i = left + 1; i <= right; ++i) {
        if ((*comp)(v[i], v[left]) < 0) {
            str_swap(v, ++last, i);
        }
    }
    str_swap(v, left, last);
    str_qsort(v, left, last - 1, comp);
    str_qsort(v, last + 1, right, comp);
}
