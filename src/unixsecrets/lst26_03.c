#include <stdio.h>
#include <sys/types.h>
#include <fcntl.h>
#include <dirent.h>
#include <limits.h>
#include "picks.h"

main()
{
FILE *fpi;
int seqno;
char *given,*surname,*alias,*pw1,*pw2,*email;
char *sendr,*sendn;
char *sendl,*sends;
char *change,*oldid;
int err;
DIR *dp;
struct dirent *entry;
struct regist compar,newmember;
int fd;
int chg;
char filename[PATH_MAX];
char errmess[PATH_MAX];
int tmpwins,tmpwvs,tmplvs,tmptvs,tmpsq,tmplos;

#ifdef DEBUG
html_head();
#endif
build_cgi_env();
given=get_value("given");
surname=get_value("surname");
email=get_value("email");
alias=get_value("alias");
sendr=get_value("sendr");
sendn=get_value("sendn");
sendl=get_value("sendl");
sends=get_value("sends");
pw1=get_value("pw1");
pw2=get_value("pw2");
change=get_value("change");
oldid=get_value("oldid");
chg=atoi(change);
err=0;
if ((!given)||(!strlen(given)))
   {
   err=1;
   html_head();
   html_title("Incorrect registration");
   addlogo();
   table_error("A First Name must be supplied");
   }
if ((!surname)||(!strlen(surname)))
   {
   err=1;
   html_head();
   html_title("Incorrect registration");
   addlogo();
   table_error("A Last Name must be supplied");
   }
if ((!pw1)||(!strlen(pw1)))
   {
   err=1;
   html_head();
   html_title("Incorrect registration");
   addlogo();
   table_error("A Password must be supplied");
   }
if ((!pw2)||(!strlen(pw2)))
   {
   err=1;
   html_head();
   html_title("Incorrect registration");
   addlogo();
   table_error("A Password must be repeated");
   }
if ((pw2)&&(pw1)&&(strcmp(pw1,pw2)))
   {
   err=1;
   html_head();
   html_title("Incorrect registration");
   addlogo();
   table_error("Passwords must match");
   }
if ((given)&&(strlen(given)>250))
   {
   err=1;
   html_head();
   html_title("Incorrect registration");
   addlogo();
   table_error("Your given name is too long.<br>Please keep it under 250 characters");
   }
if ((surname)&&(strlen(surname)>250))
   {
   err=1;
   html_head();
   html_title("Incorrect registration");
   addlogo();
   table_error("Your last name is too long.<br>Please keep it under 250 characters");
   }
if (((!alias)||(!strlen(alias)))&&(given)&&(surname))
   {
   alias=(char *)malloc(strlen(given)+strlen(surname)+2);
   strcpy(alias,given);
   strcat(alias," ");
   strcat(alias,surname);
   }
if ((alias)&&(strlen(alias)>250))
   {
   err=1;
   html_head();
   html_title("Incorrect registration");
   addlogo();
   table_error("Your alias is too long.<br>Please keep it under 250 characters");
   }
if ((email)&&(strlen(email)>250))
   {
   err=1;
   html_head();
   html_title("Incorrect registration");
   addlogo();
   table_error("Your e-mail address is too long.<br>Please keep it under 250 characters");
   }
if ((pw1)&&(strlen(pw1)>250))
   {
   err=1;
   html_head();
   html_title("Incorrect registration");
   addlogo();
   table_error("Your password is too long.<br>Please keep it under 250 characters");
   }
if (!chg)
   {
#ifdef DEBUG
   printf("Before opendir\n");
#endif
   if ((dp=opendir(REG_DIR))==NULL)
      {
      err=1;
      html_head();
      html_title("Incorrect registration");
      addlogo();
      table_error("System Error:  Unable to open the registrants directory.");
      }
        else
      {
#ifdef DEBUG
      printf("Before readdir loop\n");
#endif
      while (entry=readdir(dp))
        {
        if (!strcmp(entry->d_name,".")) continue;
        if (!strcmp(entry->d_name,"..")) continue;
#ifdef DEBUG
        printf("Looking at %s\n",entry->d_name);
#endif
        sprintf(filename,"%s/%s",REG_DIR,entry->d_name);
        if ((fd=open(filename,O_RDONLY,0))<0)
          {
           err=1;
           html_head();
           html_title("Incorrect registration");
           addlogo();
           table_error("System Error:  Unable to open a registrant file.");
          }
        if (read(fd,(char *)&compar,sizeof(struct regist))!=sizeof(struct regist))
          {
           err=1;
           html_head();
           html_title("Incorrect registration");
           addlogo();
           table_error("System Error:  Unable to read a registrant file.");
          }
        close(fd);
#ifdef DEBUG
        printf("Comparing &gt;%s&lt; to &gt;%s&lt;<br>\n",alias,compar.alias);
#endif
        if (!strcmp(alias,compar.alias))
          {
           err=1;
           html_head();
           html_title("Incorrect registration");
           addlogo();
           sprintf(errmess,"The alias %s is already in use, please select another",alias);
           table_error(errmess);
          }
        }
        closedir(dp);
      }
    }
if (err)
  {
  printf("<p><center><form action=registerme.cgi method=post>\n");
  printf("<input type=hidden name=change value=%s>\n",change);
  if (chg) printf("<input type=hidden name=oldid value=%s>\n",oldid);
  printf("<table border=0 cellspacing=0 cellpadding=10 bgcolor=#bbbbff>\n");
  printf("<tr><td>\n");
  printf("<table border=0 cellspacing=0 cellpadding=5 bgcolor=#bbbbff>\n");
  printf("<tr><td align=right>First Name:</td>\n");
  printf("<td align=left><input value=\"%s\" type=text name=given size=20></td></tr>\n",(given)?given:"");
  printf("<tr><td align=right>Last Name:</td>\n");
  printf("<td align=left><input value=\"%s\" type=text name=surname size=20></td></tr>\n",(surname)?surname:"");
  printf("<tr><td align=right>Desired Alias:</td>\n");
  printf("<td align=left><input value=\"%s\" type=text name=alias size=20></td></tr>\n",(alias)?alias:"");
  printf("<tr><td align=right>E-mail Address:</td>\n");
  printf("<td align=left><input value=\"%s\" type=text name=email size=20></td></tr>\n",(email)?email:"");
  printf("<tr><td align=center><input type=checkbox name=sendr %s value=yes></td>\n",(sendr)?"checked":"");
  printf("<td align=left>Send notice when results are entered?</td></tr>\n");
  printf("<tr><td align=center><input type=checkbox name=sendn %s value=yes></td>\n",(sendn)?"checked":"");
  printf("<td align=left>Send notice when new rounds are entered?</td></tr>\n");
  printf("<tr><td align=center><input type=checkbox name=sendl %s value=yes></td>\n",(sendl)?"checked":"");
  printf("<td align=left>Send notice if a round is about to close?</td></tr>\n");
  printf("<tr><td align=center><input type=checkbox name=sends %s value=yes></td>\n",(sends)?"checked":"");
  printf("<td align=left>Send pick descriptions and news?</td></tr>\n");
  printf("<tr><td align=right>Password:</td>\n");
  printf("<td align=left><input type=password name=pw1 size=20></td></tr>\n");
  printf("<tr><td align=right>Repeat Password:</td>\n");
  printf("<td align=left><input type=password name=pw2 size=20></td></tr>\n");
  printf("<tr><td align=center colspan=2>\n");
  printf("<input type=submit value=\"Register Me\">\n");
  printf("</td></tr></table>\n");
  printf("</td></tr></table>\n");
  }
else
  {
   if (chg)
     {
      seqno=atoi(oldid);
      sprintf(filename,"%s/%d",REG_DIR,seqno);
      if ((fd=open(filename,O_RDONLY,0))<0)
        {
         html_head();
         html_title("Registration");
         addlogo();
         printf("Unable to open old record\n");
         exit(0);
        }
      if (read(fd,(struct regist *)&newmember,sizeof(struct regist))!=sizeof(struct regist))
        {
         html_head();
         html_title("Registration");
         addlogo();
         printf("Unable to read old record\n");
         exit(0);
        }
      close(fd);
      tmpwins=newmember.wins;
      tmplos=newmember.losses;
      tmpwvs=newmember.winvsspread;
      tmplvs=newmember.lossvsspread;
      tmptvs=newmember.tievsspread;
      tmpsq=newmember.square;
    }
   else
      {
       if ((fpi=fopen(SEQFILE,"r"))==NULL)
         {
          html_head();
          html_title("Registration");
          addlogo();
          table_error("Unable to register successfully");
          table_error("No seqfile");
          exit(0);
         }
       else
         {
          fscanf(fpi,"%d",&seqno);
          fclose(fpi);
          seqno++;
          if ((fpi=fopen(SEQFILE,"w"))==NULL)
            {
             html_head();
             html_title("Registration");
             addlogo();
             table_error("Unable to register successfully");
             table_error("Unwritable seqfile");
             exit(0);
            }
          else
            {
             fprintf(fpi,"%d\n",seqno);
             fclose(fpi);
             tmpwins=0;
             tmpwvs=0;
             tmplvs=0;
             tmptvs=0;
             tmpsq=0;
             tmplos=0;
            }
           }
         }
   printf("Content-type: text/html\n");
   printf("Set-cookie: %s=%d;PATH=/;EXPIRES=Wednesday, 15-Apr-1999 23:59:59 GMT\n\n",COOKIE,seqno);
   html_title("Registration");
   addlogo();
   strcpy(newmember.given,given);
   strcpy(newmember.surname,surname);
   strcpy(newmember.alias,alias);
   strcpy(newmember.email,email);
   strcpy(newmember.password,encrypt(pw1));
   newmember.wins=tmpwins;
   newmember.winvsspread=tmpwvs;
   newmember.lossvsspread=tmplvs;
   newmember.tievsspread=tmptvs;
   newmember.sendresults=(sendr)?1:0;
   newmember.sendnotice=(sendn)?1:0;
   newmember.sendstory=(sends)?1:0;
   newmember.sendlate=(sendl)?1:0;
   newmember.square=tmpsq;
   newmember.losses=tmplos;
   sprintf(filename,"%s/%d",REG_DIR,seqno);
   if ((fd=open(filename,O_WRONLY|O_CREAT|O_TRUNC,0666))<0)
     {
      table_error("Unable to open new registration");
     }
   else
     {
      if (write(fd,(char *)&newmember,sizeof(struct regist))!=sizeof(struct regist))
        {
          table_error("Unable to write new registration");
        }
      close(fd);
     }
#ifdef FOOT
      printf("Welcome to the Sagarmatha Football Picking Contest.\n");
#endif
#ifdef HOOP
      printf("Welcome to the Sagarmatha Basketball Picking Contest.\n");
#endif
      printf("You have been assigned a membership ID of <b>%d</b>\n",seqno);
      printf("If you use a different browser, different\n");
      printf("machine, or do not accept cookies, \n");
      printf("you will need to remember this ID\n");
      printf("and the password you entered to \n");
      printf("access the membership area.\n");
      printf("<pre>\n\n\n\n</pre>\n");
      printf("<center><table cellpadding=20 border=0 bgcolor=#bbffbb>\n");
      printf("<tr><td>\n");
      printf("<form action=members.cgi method=post>\n");
      printf("<input type=submit value=\"Members Only\">\n");
      printf("</form></td></tr></table>\n");
      printf("</center>\n");
    }
addfooter();
html_end();
exit(0);
}
