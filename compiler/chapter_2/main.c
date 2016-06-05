#include "globals.h"

/* set NO_PARSE to TRUE to get a scanner-only compiler */
#define NO_PARSE TRUE

/* set NO_ANALYZE to TRUE to get a parser-only compiler */
#define NO_ANALYZE FALSE

/* set NO_CODE to TRUE to get a compiler that does not generate code */
#define NO_CODE FALSE

#include "util.h"

#if NO_PARSE
    #include "scan.h"
#else
    #include "parse.h"
    #if !NO_ANALYZE
        #include "analyze.h"
        #if !NO_CODE
            #include "cgen.h"
        #endif
    #endif
#endif

/* allocate global variables */
int lineno = 0;
FILE* source;
FILE* listing;
FILE* code;

/* allocate and set tracing flags */
int EchoSource = TRUE;
int TraceScan = TRUE;
int TraceParse = TRUE;
int TraceAnalyze = TRUE;
int TraceCode = TRUE;

int Error = FALSE;

int main() {
    return 0;
}
