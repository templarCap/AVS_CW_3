#include <stdio.h>
#include <math.h>

double func(double x) {
    return pow(2, x*x + 1) + x - 3;
}

double methodChord(double prev, double curr, double e) {
    double next = 0;
    double extra;
    do {
        extra = next;
        next = curr - (func(curr) * (prev - curr) / (func(prev) - func(curr)));
        prev = curr;
        curr = extra;
    } while ((next > curr && (next - curr) > e) || ((curr - next) > e));
    return next;
}


void print(double answer, int file, double from, double to) {
    if (!file) {
        if (from > answer || to < answer) {
            printf("Previous interval is incorrect: (%d, %d)\n", (int)from, (int)to);
            printf("Correct interval from %d to %d\n", (int)answer, (int)answer + 1);
        }
        printf("%f", answer);
    } else {
        FILE *fout;
        fout = fopen("output.txt", "w");
        if (from > answer || to < answer) {
            fprintf(fout, "Previous interval is incorrect: (%d, %d)\n", (int) from, (int)to);
            fprintf(fout, "Correct interval from %d to %d\n", (int)answer, (int)answer + 1);
        }
        fprintf(fout, "%f", answer);
        fclose(fout);
    }
}

int main(int argc, __attribute__((unused)) char *argv[]) {
    int file = argc != 1 ? 1 : 0;
    double from = 2;
    double to = 3;
    double eps = 0.00001;
    double result = methodChord(from, to, eps);
    print(result, file, from, to);
    return 0;
}

