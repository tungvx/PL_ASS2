#include <string.h>
#include <stdio.h>
#include "dict.h"
#include "gc.h"

void updateHeight(dict *d);
int getHeight(dict *d);
void balance(dict *d);
void rotateLeft(dict *d);
void rotateRight(dict *d);
void print(dict *d);

dict newNode(char *key, char *content){
    dict result = GC_MALLOC(sizeof(struct node));
    result->key = key;
    result->content = content;
    result->height = 0;
    return result;
}

void add(dict *d, char *key, char *content){
    dict root = *d;
    dict new_node = newNode(key, content);
    if (root == NULL) *d = new_node;
    else {
	int compare = strcmp(key, root->key);
	if (compare == 0) root->content = content;
	else if (compare > 0){
	    add(&root->right, key, content);
	} else {
	    add(&root->left, key, content);
	}
    }

    //update height of the current node:
    updateHeight(d);
    balance(d);
}

char *find(dict *d, char *key){
    dict root = *d;
    if (root == NULL) return NULL;
    int compare = strcmp(key, root->key);
    if (compare == 0) return root->content;
    else if (compare > 0){
	return find(&root->right, key);
    } else {
	return find(&root->left, key);
    }
}

void balance(dict *d){
    dict root = *d;
    if (root == NULL) return;
    int diff = getHeight(&root->left) - getHeight(&root->right);
    if (diff > 1){
	dict left = root->left;
	if (getHeight(&left->right) > getHeight(&left->left)) rotateLeft(&root->left);
	rotateRight(d);
    }else if (diff < -1){
	dict right = root->right;
	if (getHeight(&right->left) > getHeight(&right->right)) rotateRight(&root->right);
	rotateLeft(d);
    }
}

void rotateLeft(dict *d){
    dict root = *d;
    if (root == NULL) return;
    dict right = root->right;
    if (right == NULL) return;
    root->right = right->left;
    right->left = root;
    *d = right;
}

void rotateRight(dict *d){
    dict root = *d;
    if (root == NULL) return;
    dict left = root->left;
    if (left == NULL) return;
    root->left = left->right;
    left->right = root;
    *d = left;
}

void updateHeight(dict *d){
    dict temp = *d;
    if (temp == NULL) return;
    int height = getHeight(&temp->left);
    int rightHeight = getHeight(&temp->right);
    if (height < rightHeight) height = rightHeight;
    temp->height = ++height;
}

int getHeight(dict *d){
    if (*d == NULL) return 0;
    else return ((*d)->height);
}

void print(dict *d){
    dict temp = *d;
    if (temp == NULL){
	printf("L");
    } else {
	printf("(");
	print(&temp->left);
	printf(", %s:%d, ", temp->key, temp->height);
	print(&temp->right);
	printf(")");
    }
}
