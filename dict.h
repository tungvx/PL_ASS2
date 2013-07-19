#ifndef _DICT_H_
#define _DICT_H_

struct node {
    char *key;
    char *content;
    int height;
    struct node *left;
    struct node *right;
};

typedef struct node *dict;

dict newNode(char *key, char *content);
void add(dict *d, char *key, char *value);
char *find(dict *d, char *key);

#endif
