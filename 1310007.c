#include <stdio.h>
#include "dict.h"
#include "gc.h"

int main(){
    GC_INIT();
    dict *d = GC_MALLOC(sizeof(dict));
    print(d);
    return 0;
}
