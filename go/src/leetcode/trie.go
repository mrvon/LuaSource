package main

import "fmt"

/*
def find(node, key):
    for char in key:
        if char in node.children:
            node = node.children[char]
        else:
            return None
    return node

def insert(root : node, s : string):
    node = root
    i    = 0
    n    = length(s)

    while i < n:
        if node.child(s[i]) != nil:
            node = node.child(s[i])
            i = i + 1
        else:
            break

    (* append new nodes, if necessary *)
    while i < n:
        node.child(s[i]) = new node
        node = node.child(s[i])
        i = i + 1
*/

type Trie struct {
	children []*Trie
}

func tonumber(b byte) int {
	if b >= 'a' && b <= 'z' {
		return int(b - 'a')
	} else if b >= 'A' && b <= 'Z' {
		return int(b - 'A' + 26)
	} else {
		panic("Invalid character.")
	}
}

func create() *Trie {
	new := &Trie{}
	new.children = make([]*Trie, 26*2)
	return new
}

func find(node *Trie, s string) *Trie {
	for i := 0; i < len(s); i++ {
		node = node.children[tonumber(s[i])]
		if node == nil {
			return nil
		} else {
			return node
		}
	}
	return node
}

func findvalue(node *Trie, s string) string {
	var val []byte
	for i := 0; i < len(s); i++ {
		node = node.children[tonumber(s[i])]
		if node == nil {
			return ""
		}
		val = append(val, s[i])
	}
	return string(val)
}

func insert(node *Trie, s string) {
	i := 0
	n := len(s)

	for i < n {
		next := node.children[tonumber(s[i])]
		if next == nil {
			break
		} else {
			node = next
			i++
		}
	}

	for i < n {
		new := create()
		node.children[tonumber(s[i])] = new
		node = node.children[tonumber(s[i])]
		i++
	}
}

func main() {
	trie := create()

	insert(trie, "hello")
	insert(trie, "world")
	insert(trie, "quick")
	insert(trie, "sort")
	insert(trie, "Definitive")

	fmt.Println(findvalue(trie, "k"))
	fmt.Println(findvalue(trie, "quicksort"))
	fmt.Println(findvalue(trie, "hel"))
	fmt.Println(findvalue(trie, "hello"))
	fmt.Println(findvalue(trie, "helloworld"))
	fmt.Println(findvalue(trie, "Definition"))
	fmt.Println(findvalue(trie, "Definitive"))
	fmt.Println(findvalue(trie, "definitive"))
}
