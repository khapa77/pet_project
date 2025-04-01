BEGIN {numwords = 0;}

{
 if ($1 ~ "Hello")
    printf("\n%s %s", $1, "World");
 else
    printf("!");

 numwords = numwords + NF;
}

END {printf("\n\nNumber of lines in data file: %d\n", NR);
     printf("Number of words in data file: %d\n", numwords);}
