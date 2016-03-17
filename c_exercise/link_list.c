#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

struct node {
    struct node *next;
    uint32_t handle;
};

// best pratice design
struct link_list {
    struct node head;
    struct node *tail;
};

static struct node *
link_clear(struct link_list *list) {
    struct node * ret = list->head.next;
    list->head.next = NULL;
    list->tail = &(list->head);

    return ret;
}

static void
link(struct link_list *list, struct node *node) {
    list->tail->next = node;
    list->tail = node;
    node->next = NULL;
}

static void
print(struct link_list *list) {
    struct node * current = link_clear(list);
    printf("List: ");
    while (current) {
        printf("%d ", current->handle);
        current = current->next;
    }
    printf("\n");
}

static struct node*
new_node() {
    static uint32_t handle = 0;
    handle++;

    struct node *node = (struct node*)malloc(sizeof(*node));
    node->handle = handle;

    return node;
}

int main(int argc, char const* argv[])
{
    struct link_list *list = (struct link_list*)malloc(sizeof(*list));
    // init link_list before use it.
    link_clear(list);

    link(list, new_node());
    link(list, new_node());
    link(list, new_node());
    print(list);

    print(list);

    link(list, new_node());
    print(list);

    return 0;
}
