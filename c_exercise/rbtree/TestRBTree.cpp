#include <iostream>
#include <string>
#include "RBTree.hpp"
#include <set>

template <typename CONTAINER>
void print(const CONTAINER& con)
{
    for(typename CONTAINER::iterator iter = con.Begin();
        iter != con.End(); ++iter)
    {
        std::cout << *iter << " ";
    }
    std::cout << std::endl;
}

template <typename CONTAINER>
void reverse_print(const CONTAINER& con)
{
    for(typename CONTAINER::reverse_iterator iter = con.Rbegin();
        iter != con.Rend(); ++iter)
    {
        std::cout << *iter << " ";
    }
    std::cout << std::endl;
}

template <typename CONTAINER>
void print_size(const CONTAINER& con)
{
    std::cout << "Size: " << con.Size() << std::endl;
}

template <typename CONTAINER, typename T>
void try_find(const CONTAINER& con, T value)
{
    typename CONTAINER::iterator find_iter = con.Find(value);
    if(find_iter != con.End())
    {
        std::cout << "We found " << *find_iter << std::endl;
    }
    else
    {
        std::cout << "We not found " << value << std::endl;
    }
}

template <typename CONTAINER>
void print_max(const CONTAINER& con)
{
    RBTree<std::string>::const_iterator max_iter = con.FindMaximum();
    if(max_iter != con.End())
    {
        std::cout << "Max: " << *max_iter << std::endl;
    }
    else
    {
        std::cout << "CONTAINER empty" << std::endl;
    }
}

template <typename CONTAINER>
void print_min(const CONTAINER& con)
{
    RBTree<std::string>::const_iterator min_iter = con.FindMinimum();
    if(min_iter != con.End())
    {
        std::cout << "Min: " << *min_iter << std::endl;
    }
    else
    {
        std::cout << "CONTAINER empty" << std::endl;
    }
}

int main()
{
    RBTree<std::string> rb_tree;

    rb_tree.Insert("GuangZhou");
    rb_tree.Insert("Tencent");
    rb_tree.Insert("Weixin");
    rb_tree.Insert("Foo");

    print(rb_tree);
    reverse_print(rb_tree);
    print_size(rb_tree);

    try_find(rb_tree, "Foo");

    assert(rb_tree.Find("Foo") != rb_tree.End());
    rb_tree.Delete("Foo");
    assert(rb_tree.Find("Foo") == rb_tree.End());

    try_find(rb_tree, "Foo");
    try_find(rb_tree, "Weixin");

    print_size(rb_tree);

    print_max(rb_tree);
    print_min(rb_tree);

    rb_tree.MakeEmpty();

    print_size(rb_tree);
    print_max(rb_tree);
    print_min(rb_tree);
    assert(rb_tree.Begin() == rb_tree.End());

    return 0;
}
