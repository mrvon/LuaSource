#include <iostream>
#include <map>
#include <set>
#include <string>
#include <vector>

using namespace std;

void test() {
    map<string, size_t> word_count;
    set<string> exclude = {"The", "But", "And", "Or", "An", "A",
                           "the", "but", "and", "or", "an", "a"};
    string word;

    while (cin >> word) {
        if (exclude.find(word) == exclude.end()) {
            ++word_count[word];
        }
    }

    for (const auto& w : word_count) {
        // print the result
        cout << w.first << " occurs " << w.second
             << ((w.second > 1) ? " times" : " time") << endl;
    }
}

void test2() {
    vector<int> ivec;

    for (vector<int>::size_type i = 0; i != 10; ++i) {
        ivec.push_back(i);
        ivec.push_back(i);
    }

    set<int> iset(ivec.begin(), ivec.end());
    multiset<int> miset(ivec.cbegin(), ivec.cend());

    cout << ivec.size() << endl;
    cout << iset.size() << endl;
    cout << miset.size() << endl;
}

class TextBlock {
public:
    TextBlock(string t) : text(t) {
    }

    const char& operator[](size_t position) const {
        return text[position];
    }

    char& operator[](size_t position) {
        return text[position];
    }

private:
    string text;
};

void test3() {
    TextBlock tb("hello");
    tb[0] = 'f';
    cout << tb[0] << endl;
    const TextBlock ctb("world");
    cout << ctb[0] << endl;
}

class X {};

class Y : public virtual X {};

class Z : public virtual X {};

int main() {
    cout << sizeof(X) << endl;
    X a;
    X b;
    cout << &a << endl << &b << endl;
    cout << sizeof(Y) << endl;
    cout << sizeof(Z) << endl;
}
