#include <stdio.h>
#include <string.h>

int longestsubstring(char *s){

    int i = 0, size = strlen(s), ascii[256] = {0}, count, highest = 0, start = 0;

    for(i; i < size; i++){
        if(ascii[s[i]] > start) start = ascii[s[i]];

        ascii[s[i]] = i+1;

        count = i - start + 1;
        if(highest < count) highest = count;
    }
    return highest;
}

int main(){

    char p[] = "abcabcdabcabc";

    printf("highest: %d\n", longestsubstring(p));

    return 0;

}
