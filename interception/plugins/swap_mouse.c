#include <stdio.h>
#include <stdlib.h>
#include <linux/input.h>

int main(void) {
    setbuf(stdin, NULL), setbuf(stdout, NULL);

    struct input_event event;
    while (fread(&event, sizeof(event), 1, stdin) == 1) {
        if (event.type == EV_KEY) {
            if (event.code == BTN_LEFT)
                event.code = BTN_RIGHT;
            else if (event.code == BTN_RIGHT)
                event.code = BTN_LEFT;
        }
        fwrite(&event, sizeof(event), 1, stdout);
    }
}
