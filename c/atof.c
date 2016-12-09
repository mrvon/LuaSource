#include <ctype.h>
#include "calc.h"

double kr_atof(char s[])
{
    double val;
    double power;
    double tval;
    double exp;
    int i;
    int k;
    int sign;
    int esign;

    for (i = 0; isspace(s[i]); ++i)
        ;

    sign = (s[i] == '-') ? -1 : 1;
    if (s[i] == '+' || s[i] == '-')
        ++i;
    for (val = 0.0; isdigit(s[i]); ++i)
        val = 10.0 * val + (s[i] - '0');
    if (s[i] == '.')
        ++i;
    for (power = 1.0; isdigit(s[i]); ++i) {
        val = 10.0 * val + (s[i] - '0');
        power *= 10.0;
    }
    if (s[i] == 'e' || s[i] == 'E')
        ++i;
    esign = (s[i] == '-') ? -1 : 1;
    if (s[i] == '+' || s[i] == '-')
        ++i;
    for (exp = 0.0; isdigit(s[i]); ++i) {
        exp = 10.0 * exp + (s[i] - '0');
    }

    tval = sign * val / power;

    if (exp == 0.0) {
        return tval;
    }
    else {
        if (esign > 0) {
            for (k = exp; k > 0; k--) {
                tval *= 10;
            }
            return tval;
        }
        else {
            for (k = exp; k > 0; k--) {
                tval *= 0.1;
            }
            return tval;
        }
    }
}
