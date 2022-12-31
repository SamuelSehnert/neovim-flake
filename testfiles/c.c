#include <stdio.h>

#define test 10

struct Books {
   char  title[50];
   char  author[50];
   char  subject[100];
   int   book_id;
};

int main (int argc, char *argv[])
{
    struct Books b;
    memcpy(b.author, "nice", 5);
    float x = 1.5 * test;
    printf("%f\n", test * x);
    return 0;
}
