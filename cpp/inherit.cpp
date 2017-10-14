#include <iostream>

using namespace std;

class A {
public:
    virtual void fuck() {
        cout << "A" << endl;
    }
};

class B : public A {
public:
    virtual void fuck() {
        cout << "B" << endl;
    }
};

class C : public B {
};

int main() {
    A a;
    B b;
    C c;

    A* f = new A;
    f->fuck();

    f = new B;
    f->fuck();

    f = new C;
    f->fuck();

    // a.fuck();
    // b.fuck();
    // c.fuck();
}
