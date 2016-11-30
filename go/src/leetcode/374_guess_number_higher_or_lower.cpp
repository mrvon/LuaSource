int guess(int num);

class Solution {
public:
    int guessNumber(int n) {
        int s = 1;
        int e = n;
        
        while (s <= e) {
            int m = s + (e - s) / 2;
            int g = guess(m);
            if (g == 0) {
                return m;
            } else if (g == 1) {
                s = m + 1;
            } else {
                e = m - 1;
            }
        }
        
        return s;
    }
};
