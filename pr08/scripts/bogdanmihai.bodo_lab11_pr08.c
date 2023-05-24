#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/wait.h>

#define MSG_ERR "parametru invalid"
#define FIFO_NAME "myfifo"

int main(int argc, char *argv[]) {
    if (argc != 3) {
        fprintf(stderr, MSG_ERR);
        return 1;
    }

    FILE *fp;
    FILE *out_fp = fopen(argv[2], "w");
    if (out_fp == NULL) {
        fprintf(stderr, MSG_ERR);
        return 2;
    }

    char line[100];
    fp = fopen(argv[1], "r");
    if (fp == NULL || ferror(fp)) {
        fprintf(stderr, MSG_ERR);
        return 3;
    }

    mkfifo(FIFO_NAME, 0666); // Crearea pipe-ului cu nume

    int line_count = 0;
    pid_t pid;
    while (fgets(line, sizeof(line), fp)) {
        line_count++;
        pid = fork();

        if (pid < 0) {
            fprintf(stderr, MSG_ERR);
            return 4;
        } else if (pid == 0) {
            int pipefd = open(FIFO_NAME, O_WRONLY); // Deschiderea pipe-ului pentru scriere

            int i = 0, num, sum = 0, cnt = 0;
            while (sscanf(line + i, "%d", &num) == 1) {
                i += snprintf(NULL, 0, "%d", num) + 1;
                sum += num;
                cnt++;
            }
            int average = sum / cnt;
            write(pipefd, &average, sizeof(int));

            close(pipefd);
            fclose(out_fp); // Închide fișierul de ieșire în procesul copil
            exit(0);
        }
    }

    if (pid > 0) {
        int pipefd = open(FIFO_NAME, O_RDONLY); // Deschiderea pipe-ului pentru citire

        int average;
        for (int i = 0; i < line_count; i++) {
            if (read(pipefd, &average, sizeof(int)) > 0) {
                fprintf(out_fp, "%d\n", average);
            }
        }

        close(pipefd);
        wait(NULL);
        fclose(out_fp); // Închide fișierul de ieșire în procesul părinte
    }

    fclose(fp);
    unlink(FIFO_NAME); // Ștergerea pipe-ului cu nume

    return 0;
}
