/*

Search (list, searchKey)
    x := list->header

    -- loop invariant: x->key < searchKey

    for i := list->level downto 1 do
        while x->forward[i]->key < searchKey do
            x := x->forward[i]

    -- x->key < searchKey <= x->forward[1]->key

    x := x->forward[1]

    if x->key = searchKey then
        return x->value
    else
        return failure


Insert (list, searchKey, newValue)
    local update[1..MaxLevel]

    x := list->header

    for i := list->level downto 1 do
        while x->forward[i]->key < searchKey do
            x := x->forward[i]
        -- x->key < searchKey <= x->forward[i]->key
        update[i] := x

    x := x->forward[1]

    if x->key = searchKey then
        x->value := newValue
    else
        |v| := randonLevel()
        if |v| > list->level then
            for i := list->level + 1 to |v| do
                update[i] := list->header
            list->level = |v|
        x := makeNode(|v|, searchKey, value)
        for i := 1 to level do
            x->forward[i] := update[i]->forward[i]
            update[i]->forward[i] := x


Delete(list, searchKey)
    local update[1..MaxLevel]

    x := list->header

    for i := list->level downto 1 do
        while x->forward[i]->key < searchKey do
            x := x->forward[i]
        update[i] := x

    x := x->forward[1]

    if x->key = searchKey then
        for i := 1 to list->level do
            if update[i]->forward[i] != x then
                break
            update[i]->forward[i] := x->forward[i]

        free(x)

        while list->level > 1 and list->header->forward[list->level] = NIL do
            list->level := list->level - 1


randomLevel()
    |v| := 1

    -- random() that returns a random value in [0...1)

    while random() < p and |v| < MaxLevel do
        |v| := |v| + 1

    return |v|

*/


