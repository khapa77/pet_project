#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>
#include <errno.h>
#include "picks.h"

main()
{
char *memberno;
char *buffer,*p,*q;
char filename[PATH_MAX];

build_cgi_env();
memberno=get_value("member");
if ((!memberno)&&(getenv("HTTP_COOKIE")))
  {
   buffer=(char *)malloc(strlen(getenv("HTTP_COOKIE"))+1);
   strcpy(buffer,getenv("HTTP_COOKIE"));
   p=strstr(buffer,COOKIE);
   if (p)
     {
       q=strchr(p,'=');
       if (q)
         {
          if (p=strchr(q,';')) (*p)=0;
          q++;
          memberno=q;
         }
     }
  }
if (memberno)
  {
   sprintf(filename,"%s/%s",REG_DIR,memberno);
   if (access(filename,F_OK))
      memberno=NULL;
  }
html_head();
if (!memberno)
  {
   html_title("Please Login");
   addlogo();
   printf("We cannot identify you (perhaps you don't accept\n");
   printf("cookies, or perhaps you are not registered.\n");
   printf("Or, perhaps your membership has expired.)\n");
   printf("You can enter by specifying your membership ID\n");
   printf("and password, or by registering.\n");
   printf("<p><center>\n");
   printf("<form method=post action=verify.cgi>\n");
   printf("<table cellspacing=0 cellpadding=5 border=0 bgcolor=#bbffbb>\n");
   printf("<tr><td align=right>Member ID:</td><td>\n");
   printf("<input type=text size=10 name=memberno></td></tr>\n");
   printf("<tr><td align=right>Password:</td><td>\n");
   printf("<input type=password name=password size=10></td></tr>\n");
   printf("<tr><td align=center colspan=2>\n");
   printf("<input type=submit value=\"Verify Membership\">\n");
   printf("</td></tr></table></form></center>\n");
   printf("<pre>\n\n\n\n</pre><center>\n");
   printf("<form method=post action=register.cgi>\n");
   printf("<input type=submit value=Register>\n");
   printf("</form></center>\n");
  }
else
  {
   html_title("Members Area");
   addlogo();
   printf("<center><h1>Welcome</h1></center><p>\n");
   printf("This area is accessible only by registered entrants\n");
   printf("to the Sagarmatha picking contest.\n");
   printf("You can make your picks from here, or modify\n");
   printf("your registration.  Eventually, I plan on\n");
   printf("incorporating the round summaries, and an\n");
   printf("ability for you to examine your previous picks\n");
   printf("to see trends in your picking.\n");
   printf("<p><center>\n");
   printf("<table border=0><tr>\n");
   printf("<td align=center>\n");
   printf("<form method=post action=%s/bin/newpicks.cgi>\n",BASEDIR);
   printf("<input type=hidden name=id value=%s>\n",memberno);
   printf("<input type=submit value=\"Make Picks\">\n");
   printf("</form>\n");
   printf("</td><td align=center>\n");
   printf("<form method=post action=%s/bin/dumplist.cgi>\n",BASEDIR);
   printf("<input type=hidden name=id value=%s>\n",memberno);
   printf("<input type=submit value=\"Show Picks\">\n");
   printf("</form>\n");
   printf("</td></tr><tr><td align=center>\n");
   printf("<form method=post action=%s/bin/pickhist.cgi>\n",BASEDIR);
   printf("<input type=hidden name=id value=%s>\n",memberno);
   printf("<input type=submit value=\"Pick History\">\n");
   printf("</form>\n");
   printf("</td><td align=center>\n");
   printf("<form method=post action=%s/bin/login.cgi>\n",BASEDIR);
   printf("<input type=submit value=\"Other Account\">\n");
   printf("</form>\n");
   printf("</td></tr><tr><td align=center>\n");
   printf("<form method=post action=%s/bin/chregister.cgi>\n",BASEDIR);
   printf("<input type=hidden name=id value=%s>\n",memberno);
   printf("<input type=submit value=\"Change Registration\">\n");
   printf("</form>\n");
   printf("</td><td align=center>\n");
   printf("<form method=post action=%s/bin/reloc.cgi>\n",BASEDIR);
   printf("<input type=hidden name=dest value=http://www.sagarmatha.com%s/>\n",BASEDIR);
   printf("<input type=submit value=\"Home Page\">\n");
   printf("</form>\n");
   printf("</td></tr></table>\n");
   printf("</center>\n");
  }
addfooter();
html_end();
exit(0);
}
