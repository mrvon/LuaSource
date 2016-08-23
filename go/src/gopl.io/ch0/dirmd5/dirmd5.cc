#include <iostream>
#include <sstream>
#include <fstream>
#include <map>
#include <algorithm>
#include <cstdlib>

using namespace std;

int main() {
    map<string, pair<int, int> > m;
    stringstream ss;

    ifstream fi("test.file");

    if (!fi) {
        return 0;
    }

    copy(istreambuf_iterator<char>(fi),
        istreambuf_iterator<char>(),
        ostreambuf_iterator<char>(ss));

    string s;
    string t;
    int h;
    int w;

    while (ss) {
        ss >> s;
        ss >> t;
        h = atoi(t.c_str());
        ss >> t;
        w = atoi(t.c_str());

        m.insert(make_pair(s, make_pair(h, w)));
    }

    for (auto i = m.begin(); i != m.end(); ++i) {
        cout << i->first << endl;
        cout << i->second.first << endl;
        cout << i->second.second << endl;
    }
}
