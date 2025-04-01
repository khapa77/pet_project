#include <stdio.h>
#include "custom.h"

main()
{
html_head();
html_title("Registration");
addlogo(); 
printf("You must register before entering the picking contest.\n");
printf("Your first and last names are required, as is a password.\n");
printf("All other fields are optional.\n");
printf("<p>If you accept cookies, and use the same browser from the\n");
printf("same machine, you should never need to log in to make your\n");
printf("picks.\n");
printf("<p><center><form action=registerme.cgi method=post>\n");
printf("<input type=hidden name=change value=0>\n");
printf("<table border=0 cellspacing=0 cellpadding=10 bgcolor=#bbbbff>\n");
printf("<tr><td>\n");
printf("<table border=0 cellspacing=0 cellpadding=5 bgcolor=#bbbbff>\n");
printf("<tr><td align=right>First Name:</td>\n");
printf("<td align=left><input type=text name=given size=20></td></tr>\n");
printf("<tr><td align=right>Last Name:</td>\n");
printf("<td align=left><input type=text name=surname size=20></td></tr>\n");
printf("<tr><td align=right>Desired Alias:</td>\n");
printf("<td align=left><input type=text name=alias size=20></td></tr>\n");
printf("<tr><td align=right>E-mail Address:</td>\n");
printf("<td align=left><input type=text name=email size=20></td></tr>\n");
printf("<tr><td align=center><input type=checkbox name=sendr value=yes></td>\n");
printf("<td align=left>Send notice when results are entered?</td></tr>\n");
printf("<tr><td align=center><input type=checkbox name=sendn value=yes></td>\n");
printf("<td align=left>Send notice when new rounds are entered?</td></tr>\n");
printf("<tr><td align=center><input type=checkbox name=sendl value=yes></td>\n");
printf("<td align=left>Send notice if a round is about to close?</td></tr>\n");
printf("<tr><td align=center><input type=checkbox name=sends value=yes></td>\n");
printf("<td align=left>Send pick descriptions and news?</td></tr>\n");
printf("<tr><td align=right>Password:</td>\n");
printf("<td align=left><input type=password name=pw1 size=20></td></tr>\n");
printf("<tr><td align=right>Repeat Password:</td>\n");
printf("<td align=left><input type=password name=pw2 size=20></td></tr>\n");
printf("<tr><td align=center colspan=2>\n");
printf("<input type=submit value=\"Register Me\">\n");
printf("</td></tr></table>\n");
printf("</td></tr></table>\n");
printf("</form>\n");
printf("<p><form method=post action=%s/bin/reloc.cgi>\n",BASEDIR);
printf("<input type=hidden name=dest value=http://www.sagarmatha.com%s/>\n",BASEDIR);
printf("<input type=submit value=\"Home Page\">\n");
printf("</form></center>\n");
addfooter();
html_end();
exit(0);
}
