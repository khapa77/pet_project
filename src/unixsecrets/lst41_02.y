%{
#include <time.h>

struct tm timer;
int yylval;
%}
%token COMMA SLASH INTEGER MONTERM DAYSPEC COLON
%%
DATE : DATE_SPEC { return 0; }
     | DATE_SPEC TIME_SPEC { return 0; }
     ;
DATE_SPEC : DAYOFYEAR COMMA YEAR
          | DAYOFYEAR
          ;
DAYOFYEAR : DATES
          | DAYOFWEEK DATES
          ;
DATES : MONTH DAY
      | MONTH SLASH DAY
      | DAY MONTH
      | DAY SLASH MONTH
      ;
YEAR : SLASH YR
     | YR
     ;
YR : INTEGER { timer.tm_year=yylval%100; }
   ;
MONTH : MONTERM { timer.tm_mon=yylval; }
      | INTEGER { timer.tm_mon=yylval-1; }
      ;
DAY : INTEGER { timer.tm_mday=yylval; }
    ;
DAYOFWEEK : DAYSPEC { timer.tm_wday=yylval; }
          ;
TIME_SPEC : HOUR COLON MINUTE
          | HOUR COLON MINUTE COLON SECOND
          ;
HOUR : INTEGER { timer.tm_hour=yylval; }
     ;
MINUTE : INTEGER { timer.tm_min=yylval; }
       ;
SECOND : INTEGER { timer.tm_sec=yylval; }
       ;
%%
main ()
{
timer.tm_year=95;
timer.tm_mon=11;
timer.tm_mday=9;
timer.tm_hour=19;
timer.tm_min=27;
timer.tm_sec=0;
yyparse();
printf("Integer time is %d\n",(int)mktime(&timer));
}
