static char cgi_h_id[]="$Id: cgi.h,v 1.2 1998/05/24 16:15:59 james Exp $";

/*
 * $Log: cgi.h,v $
 * Revision 1.2  1998/05/24 16:15:59  james
 * ������ ������������� RCS ��������� � ����� ������������ 
 *
 *
 */

struct cgienv {
        char *cgivar;
        char *cgival;
        struct cgienv *next;
        };

void *sbbs_malloc(int);
