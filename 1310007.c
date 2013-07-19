#include <stdio.h>
#include "dict.h"
#include "gc.h"

int main(){
    GC_INIT();
    dict *d;
    d = GC_MALLOC(sizeof(dict));
    add(d, "Tunbg", "deptrai");
    printf("%s\n", find(d, "Tunbg"));
    return 0;
}
