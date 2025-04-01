%{
#include "y.tab.h"
extern int yylval;
%}
%%
"","     { return COMMA; }
""/"     { return SLASH; }
"":"     { return COLON; }
[1-9][0-9]*     { yylval=atoi(yytext); return INTEGER; }
Sun     { yylval=0; return DAYSPEC; }
Sunday  { yylval=0; return DAYSPEC; }
Mon     { yylval=1; return DAYSPEC; }
Monday  { yylval=1; return DAYSPEC; }
Tue     { yylval=2; return DAYSPEC; }
Tuesday { yylval=2; return DAYSPEC; }
Wed     { yylval=3; return DAYSPEC; }
Wednesday       { yylval=3; return DAYSPEC; }
Thu     { yylval=4; return DAYSPEC; }
Thursday        { yylval=4; return DAYSPEC; }
Fri     { yylval=5; return DAYSPEC; }
Friday  { yylval=5; return DAYSPEC; }
Sat     { yylval=6; return DAYSPEC; }
Saturday        { yylval=6; return DAYSPEC; }
Jan     { yylval=0; return MONTERM; }
January { yylval=0; return MONTERM; }
Feb     { yylval=1; return MONTERM; }
February        { yylval=1; return MONTERM; }
Mar     { yylval=2; return MONTERM; }
March   { yylval=2; return MONTERM; }
Apr     { yylval=3; return MONTERM; }
April   { yylval=3; return MONTERM; }
May     { yylval=4; return MONTERM; }
May     { yylval=4; return MONTERM; }
Jun     { yylval=5; return MONTERM; }
June    { yylval=5; return MONTERM; }
Jul     { yylval=6; return MONTERM; }
July    { yylval=6; return MONTERM; }
Aug     { yylval=7; return MONTERM; }
August  { yylval=7; return MONTERM; }
Sep     { yylval=8; return MONTERM; }
September       { yylval=8; return MONTERM; }
Oct     { yylval=9; return MONTERM; }
October { yylval=9; return MONTERM; }
Nov     { yylval=10; return MONTERM; }
November        { yylval=10; return MONTERM; }
Dec     { yylval=11; return MONTERM; }
December        { yylval=12; return MONTERM; }
.       {}
"\n"    {}
