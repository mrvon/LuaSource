#ifndef __RED_BLACK_TREE_H__
#define __RED_BLACK_TREE_H__

#include <iterator>
#include <cstddef>
#include <cassert>

enum RBNodeColor
{
    RED,
    BLACK
};

template <typename ElementType>
struct RBTreeNode
{
    RBTreeNode()
    {
        Element     = ElementType();
        Color       = RED;
        Parent      = NULL;
        LeftChild   = NULL;
        RightChild  = NULL;
    }

    ElementType         Element;
    RBNodeColor         Color;
    RBTreeNode*         Parent;
    RBTreeNode*         LeftChild;
    RBTreeNode*         RightChild;
};

template <typename ElementType>
class RBTree
{
    class __rb_tree_base_iterator
    {
    public:
        typedef     std::bidirectional_iterator_tag     iterator_category;
        typedef     ptrdiff_t                           difference_type;
        typedef     ptrdiff_t                           distance_type;	    // retained
        typedef     ElementType                         value_type;
        typedef     const ElementType*                  pointer;
        typedef     const ElementType&                  reference;
    };

public:

    class const_iterator : public __rb_tree_base_iterator
    {
        friend class RBTree::const_reverse_iterator;

    public:
        const_iterator(RBTreeNode<ElementType>* current_node, const RBTree<ElementType>& tree)
            : m_current_node(current_node)
            , m_tree(tree)
        {
        }

        const_iterator(const const_iterator& rhs)
            : m_current_node(rhs.m_current_node)
            , m_tree(rhs.m_tree)
        {
        }

        ElementType                 operator*() const       { return m_current_node->Element; }
        const_iterator&             operator++()            { m_current_node = m_tree.__TreeSuccessor(m_current_node); return *this; }
        const_iterator              operator++(int)         { const_iterator temp = *this; m_current_node = m_tree.__TreeSuccessor(m_current_node); return temp; }
        const_iterator&             operator--()            { m_current_node = m_tree.__TreePredecessor(m_current_node); return *this; }
        const_iterator              operator--(int)         { const_iterator temp = *this; m_current_node = m_tree.__TreePredecessor(m_current_node); return temp; }

        bool                        operator==(const const_iterator& rhs) const { return (m_current_node == rhs.m_current_node); }
        bool                        operator!=(const const_iterator& rhs) const { return ! (this->operator==(rhs)); }

    private:
        RBTreeNode<ElementType>*                        m_current_node;
        const RBTree<ElementType>&                      m_tree;
    };


    class const_reverse_iterator : public __rb_tree_base_iterator
    {
    public:
        const_reverse_iterator(RBTreeNode<ElementType>* current_node, const RBTree<ElementType>& tree)
            : m_current_node(current_node)
            , m_tree(tree)
        {
        }

        const_reverse_iterator(const const_reverse_iterator& rhs)
            : m_current_node(rhs.m_current_node)
            , m_tree(rhs.m_tree)
        {
        }

        const_reverse_iterator(const const_iterator& rhs)
            : m_current_node(rhs.m_current_node)
            , m_tree(rhs.m_tree)
        {
        }

        ElementType                 operator*() const       { return m_current_node->Element; }
        const_reverse_iterator&     operator++()            { m_current_node = m_tree.__TreePredecessor(m_current_node); return *this; }
        const_reverse_iterator      operator++(int)         { const_reverse_iterator temp = *this; m_current_node = m_tree.__TreePredecessor(m_current_node); return temp; }
        const_reverse_iterator&     operator--()            { m_current_node = m_tree.__TreeSuccessor(m_current_node); return *this; }
        const_reverse_iterator      operator--(int)         { const_reverse_iterator temp = *this; m_current_node = m_tree.__TreeSuccessor(m_current_node); return temp; }

        bool                        operator==(const const_reverse_iterator& rhs) const { return (m_current_node == rhs.m_current_node); }
        bool                        operator!=(const const_reverse_iterator& rhs) const { return ! (this->operator==(rhs)); }

    private:
        RBTreeNode<ElementType>*                        m_current_node;
        const RBTree<ElementType>&                      m_tree;
    };

    typedef const_iterator                              iterator;
    typedef const_reverse_iterator                      reverse_iterator;

public:
    RBTree();
    ~RBTree();

    const_iterator                                      Begin() const   { return FindMinimum(); }
    const_iterator                                      End() const     { return const_iterator(m_nil_node, *this); }
    const_reverse_iterator                              Rbegin() const  { return const_reverse_iterator(FindMaximum()); }
    const_reverse_iterator                              Rend() const    { return const_reverse_iterator(m_nil_node, *this); }
    void                                                MakeEmpty();
    void                                                Insert(ElementType element);
    void                                                Delete(ElementType element);
    const_iterator                                      Find(ElementType element) const;
    const_iterator                                      FindMinimum() const;
    const_iterator                                      FindMaximum() const;
    size_t                                              Size() const;

private:
    size_t                                              SlowSize();             
    void                                                InorderTreeWalk(size_t& count_of_element);

private:
    void                                                __MakeEmpty(RBTreeNode<ElementType>* tree);

    RBTreeNode<ElementType>*                            __NewNilNode();
    RBTreeNode<ElementType>*                            __NewTreeNode(ElementType element);
    void                                                __DeleteNode(RBTreeNode<ElementType>*);

    RBTreeNode<ElementType>*                            __TreeSearch(RBTreeNode<ElementType>* x, ElementType element) const;
    RBTreeNode<ElementType>*                            __TreeMinimum(RBTreeNode<ElementType>* x) const;
    RBTreeNode<ElementType>*                            __TreeMaximum(RBTreeNode<ElementType>* x) const;

    RBTreeNode<ElementType>*                            __TreePredecessor(RBTreeNode<ElementType>* x) const;
    RBTreeNode<ElementType>*                            __TreeSuccessor(RBTreeNode<ElementType>* x) const;

    void                                                __RBInsert( RBTreeNode<ElementType>* z);
    void                                                __RBInsertFixup(RBTreeNode<ElementType>* z);

    void                                                __RBTransplant(RBTreeNode<ElementType>* u, RBTreeNode<ElementType>* v);
    void                                                __RBDelete(RBTreeNode<ElementType>* z);
    void                                                __RBDeleteFixup(RBTreeNode<ElementType>* x);

    void                                                __InorderTreeWalk(RBTreeNode<ElementType>* tree, size_t& count_of_element);

    void                                                __LeftRotate( RBTreeNode<ElementType>* x );
    void                                                __RightRotate( RBTreeNode<ElementType>* x );

private:
    RBTreeNode<ElementType>*                            m_rb_tree_root;
    RBTreeNode<ElementType>*                            m_nil_node;
    size_t                                              m_size;
};



template <typename ElementType>
RBTree<ElementType>::RBTree()
{
    m_nil_node      = __NewNilNode();
    m_rb_tree_root  = m_nil_node;
    m_size          = 0;
}

template <typename ElementType>
RBTree<ElementType>::~RBTree()
{
    MakeEmpty();

    __DeleteNode(m_nil_node);
}

template <typename ElementType>
void
RBTree<ElementType>::MakeEmpty()
{
    __MakeEmpty(m_rb_tree_root);

    m_rb_tree_root = m_nil_node;
    m_size = 0;
}

template <typename ElementType>
void
RBTree<ElementType>::Insert(ElementType element)
{
    RBTreeNode<ElementType>* find_node = __TreeSearch(m_rb_tree_root, element);
    if(find_node == m_nil_node)
    {
        __RBInsert(__NewTreeNode(element));
    }
}

template <typename ElementType>
void 
RBTree<ElementType>::Delete(ElementType element)
{
    RBTreeNode<ElementType>* find_node = __TreeSearch(m_rb_tree_root, element);
    if(find_node != m_nil_node)
    {
        __RBDelete(find_node);
    }
}

template <typename ElementType>
typename RBTree<ElementType>::const_iterator
RBTree<ElementType>::Find(ElementType element) const
{
    return const_iterator(__TreeSearch(m_rb_tree_root, element), *this);
}

template <typename ElementType>
typename RBTree<ElementType>::const_iterator
RBTree<ElementType>::FindMinimum() const
{
    return const_iterator(__TreeMinimum(m_rb_tree_root), *this);
}

template <typename ElementType>
typename RBTree<ElementType>::const_iterator
RBTree<ElementType>::FindMaximum() const
{
    return const_iterator(__TreeMaximum(m_rb_tree_root), *this);
}

template <typename ElementType>
size_t
RBTree<ElementType>::Size() const
{
    return m_size;
}

template <typename ElementType>
void
RBTree<ElementType>::InorderTreeWalk(size_t& count_of_element)
{
    __InorderTreeWalk(m_rb_tree_root, count_of_element);
}

template <typename ElementType>
size_t
RBTree<ElementType>::SlowSize()
{
    size_t size_of_tree = 0;

    InorderTreeWalk(size_of_tree) ;

    return size_of_tree;
}

template <typename ElementType>
RBTreeNode<ElementType>* RBTree<ElementType>::__NewNilNode()
{
    RBTreeNode<ElementType>* nil_node = new RBTreeNode<ElementType>();
    assert(nil_node);
    
    nil_node->Color        = BLACK;
    nil_node->LeftChild    = nil_node;
    nil_node->RightChild   = nil_node;
    nil_node->Parent       = nil_node;

    return nil_node;
}

template <typename ElementType>
RBTreeNode<ElementType>* RBTree<ElementType>::__NewTreeNode(ElementType element)
{
    RBTreeNode<ElementType>* new_tree_node = new RBTreeNode<ElementType>();
    assert(new_tree_node);

    new_tree_node->Element      = element;
    new_tree_node->Color        = RED;
    new_tree_node->LeftChild    = m_nil_node;
    new_tree_node->RightChild   = m_nil_node;
    new_tree_node->Parent       = m_nil_node;

    return new_tree_node;
}

template <typename ElementType>
void
RBTree<ElementType>::__DeleteNode(RBTreeNode<ElementType>* node)
{
    delete node;
}

template <typename ElementType>
RBTreeNode<ElementType>*                            
RBTree<ElementType>::__TreeSearch(RBTreeNode<ElementType>* x, ElementType element) const
{
    if(x == m_nil_node || x->Element == element)
    {
        return x;
    }

    if(element < x->Element)
    {
        return __TreeSearch(x->LeftChild, element);
    }
    else
    {
        return __TreeSearch(x->RightChild, element);
    }
}

template <typename ElementType>
RBTreeNode<ElementType>*
RBTree<ElementType>::__TreeMinimum(RBTreeNode<ElementType>* x) const
{
    while(x->LeftChild != m_nil_node)
    {
        x = x->LeftChild;
    }
    return x;
}   

template <typename ElementType>
RBTreeNode<ElementType>*
RBTree<ElementType>::__TreeMaximum(RBTreeNode<ElementType>* x) const
{
    while(x->RightChild != m_nil_node)
    {
        x = x->RightChild;
    }
    return x;
}

template <typename ElementType>
RBTreeNode<ElementType>*                            
RBTree<ElementType>::__TreePredecessor(RBTreeNode<ElementType>* x) const
{
    if(x->LeftChild != m_nil_node)
    {
        return __TreeMaximum(x->LeftChild);
    }

    RBTreeNode<ElementType>* y = x->Parent;
    while(y != m_nil_node && x == y->LeftChild)
    {
        x = y;
        y = y->Parent;
    }
    return y;
}

template <typename ElementType>
RBTreeNode<ElementType>*                            
RBTree<ElementType>::__TreeSuccessor(RBTreeNode<ElementType>* x) const
{
    if(x->RightChild != m_nil_node)
    {
        return __TreeMinimum(x->RightChild);
    }

    RBTreeNode<ElementType>* y = x->Parent;
    while(y != m_nil_node && x == y->RightChild)
    {
        x = y;
        y = y->Parent;
    }
    return y;
}

template <typename ElementType>
void 
RBTree<ElementType>::__MakeEmpty(RBTreeNode<ElementType>* tree)
{
    if( tree != m_nil_node )
    {
        __MakeEmpty( tree->LeftChild );
        __MakeEmpty( tree->RightChild );

        __DeleteNode(tree);
    }
}

template <typename ElementType>
void 
RBTree<ElementType>::__RBInsert(RBTreeNode<ElementType>* z)
{
    assert(z);

    ++m_size;
    
    RBTreeNode<ElementType>* y = m_nil_node;            // trailing pointer of x
    RBTreeNode<ElementType>* x = m_rb_tree_root;

    while(x != m_nil_node)
    {
        y = x;

        if(z->Element < x->Element)
        {
            x = x->LeftChild;
        }
        else
        {
            x = x->RightChild;
        }
    }

    z->Parent = y;

    if(y == m_nil_node)
    {
        m_rb_tree_root = z;
    }
    else if(z->Element < y->Element)
    {
        y->LeftChild = z;
    }
    else
    {
        y->RightChild = z;
    }

    z->LeftChild    = m_nil_node;
    z->RightChild   = m_nil_node;
    z->Color        = RED;

    __RBInsertFixup(z);
}

template <typename ElementType>
void 
RBTree<ElementType>::__RBInsertFixup(RBTreeNode<ElementType>* z)
{
    while(z->Parent->Color == RED)
    {
        if(z->Parent == z->Parent->Parent->LeftChild)
        {
            RBTreeNode<ElementType>* y = z->Parent->Parent->RightChild;
            if(y->Color == RED)
            {
                z->Parent->Color            = BLACK;        // CASE 1
                y->Color                    = BLACK;        // CASE 1
                z->Parent->Parent->Color    = RED;          // CASE 1
                z = z->Parent->Parent;                      // CASE 1
            }
            else
            {
                if(z == z->Parent->RightChild)          
                {       
                    z = z->Parent;                          // CASE 2
                    __LeftRotate(z);                        // CASE 2
                }
                z->Parent->Color            = BLACK;        // CASE 3
                z->Parent->Parent->Color    = RED;          // CASE 3
                __RightRotate(z->Parent->Parent);           // CASE 3 
            }
        }
        else
        {
            RBTreeNode<ElementType>*y = z->Parent->Parent->LeftChild;
            if(y->Color == RED)
            {
                z->Parent->Color            = BLACK;        // CASE 1
                y->Color                    = BLACK;        // CASE 1
                z->Parent->Parent->Color    = RED;          // CASE 1
                z = z->Parent->Parent;                      // CASE 1
            }
            else
            {
                if(z == z->Parent->LeftChild)
                {
                    z = z->Parent;                          // CASE 2
                    __RightRotate(z);                       // CASE 2    
                }
                z->Parent->Color            = BLACK;        // CASE 3
                z->Parent->Parent->Color    = RED;          // CASE 3
                __LeftRotate(z->Parent->Parent);            // CASE 3 
            }
        }
    }

    m_rb_tree_root->Color = BLACK;
}

template <typename ElementType>
void                                                
RBTree<ElementType>::__RBTransplant(RBTreeNode<ElementType>* u, RBTreeNode<ElementType>* v)
{  
    if(u->Parent == m_nil_node)
    {
        m_rb_tree_root = v;
    }
    else if(u == u->Parent->LeftChild)
    {
        u->Parent->LeftChild = v;
    }
    else
    {
        u->Parent->RightChild = v;
    }

    v->Parent = u->Parent;
}

template <typename ElementType>
void
RBTree<ElementType>::__RBDelete(RBTreeNode<ElementType>* z)
{
    --m_size;

    RBTreeNode<ElementType>* x      = m_nil_node;
    RBTreeNode<ElementType>* y      = z;
    RBNodeColor y_original_color    = y->Color;

    if(z->LeftChild == m_nil_node)
    {
        x = z->RightChild;
        __RBTransplant(z, z->RightChild);
    }
    else if(z->RightChild == m_nil_node)
    {
        x = z->LeftChild;
        __RBTransplant(z, z->LeftChild);
    }
    else
    {
        y = __TreeMinimum(z->RightChild);
        y_original_color = y->Color;
        x = y->RightChild;

        if(y->Parent == z)
        {
            if(x == m_nil_node)
            {
                x->Parent = y;      // This Line is Very Important
            }
            else
            {
                assert(x->Parent == y);
            }
        }
        else 
        {
            __RBTransplant(y, y->RightChild);
            y->RightChild = z->RightChild;
            y->RightChild->Parent = y;
        }

        __RBTransplant(z, y);
        y->LeftChild = z->LeftChild;
        y->LeftChild->Parent = y;

        y->Color = z->Color;
    }

    __DeleteNode(z);

    if(y_original_color == BLACK)
    {
        __RBDeleteFixup(x);
    }
}

template <typename ElementType>
void
RBTree<ElementType>::__RBDeleteFixup(RBTreeNode<ElementType>* x)
{
    while(x != m_rb_tree_root && x->Color == BLACK)
    {
        if(x == x->Parent->LeftChild)
        {
            RBTreeNode<ElementType>* w = x->Parent->RightChild;

            if(w->Color == RED)
            {
                w->Color            = BLACK;                    // CASE 1
                x->Parent->Color    = RED;                      // CASE 1
                __LeftRotate(x->Parent);                        // CASE 1
                w = x->Parent->RightChild;                      // CASE 1
            }

            if(w->LeftChild->Color == BLACK && w->RightChild->Color == BLACK)
            {
                w->Color = RED;                                 // CASE 2
                x = x->Parent;                                  // CASE 2
            }
            else
            {
                if(w->RightChild->Color == BLACK)
                {
                    w->LeftChild->Color = BLACK;                // CASE 3
                    w->Color            = RED;                  // CASE 3
                    __RightRotate(w);                           // CASE 3
                    w = x->Parent->RightChild;                  // CASE 3
                }

                w->Color                = x->Parent->Color;     // CASE 4
                x->Parent->Color        = BLACK;                // CASE 4
                w->RightChild->Color    = BLACK;                // CASE 4
                __LeftRotate(x->Parent);                        // CASE 4
                x = m_rb_tree_root;                             // CASE 4
            }
        }
        else
        {
            RBTreeNode<ElementType>* w = x->Parent->LeftChild;

            if(w->Color == RED)
            {
                w->Color            = BLACK;                    // CASE 1
                x->Parent->Color    = RED;                      // CASE 1
                __RightRotate(x->Parent);                       // CASE 1
                w = x->Parent->LeftChild;                       // CASE 1
            }

            if(w->RightChild->Color == BLACK && w->LeftChild->Color == BLACK)
            {
                w->Color = RED;                                 // CASE 2
                x = x->Parent;                                  // CASE 2
            }
            else
            {
                if(w->LeftChild->Color == BLACK)
                {
                    w->RightChild->Color    = BLACK;            // CASE 3
                    w->Color                = RED;              // CASE 3
                    __LeftRotate(w);
                    w = x->Parent->LeftChild;
                }

                w->Color = x->Parent->Color;                    // CASE 4
                x->Parent->Color    = BLACK;                    // CASE 4
                w->LeftChild->Color = BLACK;                    // CASE 4
                __RightRotate(x->Parent);                       // CASE 4
                x = m_rb_tree_root;                             // CASE 4
            }
        }
    }

    x->Color = BLACK;
}

template <typename ElementType>
void 
RBTree<ElementType>::__InorderTreeWalk(RBTreeNode<ElementType>* tree, size_t& count_of_element)
{
    if(tree != m_nil_node)
    {
        __InorderTreeWalk(tree->LeftChild, count_of_element);
        ++count_of_element;
        __InorderTreeWalk(tree->RightChild, count_of_element);
    }
}

template <typename ElementType>
void
RBTree<ElementType>::__LeftRotate( RBTreeNode<ElementType>* x )
{
    RBTreeNode<ElementType>* y  = x->RightChild;    // Set y
    x->RightChild               = y->LeftChild;     // Turn y's left subtree into x's right subtree

    if(y->LeftChild != m_nil_node)
    {
        y->LeftChild->Parent = x;
    }
    y->Parent = x->Parent;                          // Link x's parent to y

    if(x->Parent == m_nil_node)
    {
        m_rb_tree_root = y;
    }
    else if(x == x->Parent->LeftChild)
    {
        x->Parent->LeftChild = y;
    }
    else
    {
        x->Parent->RightChild = y;
    }

    y->LeftChild    = x;                            // Put x on y's left
    x->Parent       = y;
}

template <typename ElementType>
void
RBTree<ElementType>::__RightRotate( RBTreeNode<ElementType>* y )
{
    RBTreeNode<ElementType>* x  = y->LeftChild;     // Set x
    y->LeftChild                = x->RightChild;    // Turn x's right subtree into y's left subtree
    if(x->RightChild != m_nil_node)
    {
        x->RightChild->Parent = y;
    }
    x->Parent = y->Parent;                          // Link y's parent to x

    if(y->Parent == m_nil_node)
    {
        m_rb_tree_root = x;
    }
    else if(y == y->Parent->LeftChild)
    {
        y->Parent->LeftChild = x;
    }
    else
    {
        y->Parent->RightChild = x;
    }

    x->RightChild   = y;                            // Put y on x's right
    y->Parent       = x;
}


#endif
