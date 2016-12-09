void shellsort(int v[], int n)
{
    int gap;
    int i;
    int j;
    int temp;

    for (gap = n / 2; gap > 0; gap /= 2) {
        for (i = gap; i < n; i++) {
            for (j = i - gap; j >= 0 && v[j] > v[j + gap]; j -= gap) {
                temp = v[j];
                v[j] = v[j + gap];
                v[j + gap] = temp;
            }
        }
    }
}

/* when gap is 1 */
void __shellsort(int v[], int n)
{
    int i;
    int j;
    int temp;

    for (i = 1; i < n; i++) {
        for (j = i - 1; j >= 0 && v[j] > v[j + 1]; j -= 1) {
            temp = v[j];
            v[j] = v[j + 1];
            v[j + 1] = temp;
        }
    }
}
