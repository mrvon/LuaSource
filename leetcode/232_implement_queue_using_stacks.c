#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

typedef struct {
    int* buf;
    int top;
} Stack;

void stackCreate(Stack *stack, int maxSize) {
    stack->buf = malloc(sizeof(int) * maxSize);
    stack->top = 0;
}

void stackPush(Stack *stack, int element) {
    stack->buf[stack->top] = element;
    stack->top++;
}

void stackPop(Stack *stack) {
    stack->top--;
}

int stackPeek(Stack *stack) {
    return stack->buf[stack->top-1];
}

bool stackEmpty(Stack *stack) {
    if (stack->top == 0) {
        return true;
    } else {
        return false;
    }
}

void stackDestroy(Stack *stack) {
    free(stack->buf);
}

typedef struct {
    Stack s1;
    Stack s2;
} Queue;

/* Create a queue */
void queueCreate(Queue *queue, int maxSize) {
    stackCreate(&(queue->s1), maxSize);
    stackCreate(&(queue->s2), maxSize);
}

/* Push element x to the back of queue */
void queuePush(Queue *queue, int element) {
    stackPush(&(queue->s1), element);
}

/* Removes the element from front of queue */
void queuePop(Queue *queue) {
    if (stackEmpty(&(queue->s2))) {
        while (!stackEmpty(&(queue->s1))) {
            stackPush(&(queue->s2),
                    stackPeek(&(queue->s1)));
            stackPop(&(queue->s1));
        }
    }

    stackPop(&(queue->s2));
}

/* Get the front element */
int queuePeek(Queue *queue) {
    if (stackEmpty(&(queue->s2))) {
        while (!stackEmpty(&(queue->s1))) {
            stackPush(&(queue->s2),
                    stackPeek(&(queue->s1)));
            stackPop(&(queue->s1));
        }
    }
    return stackPeek(&(queue->s2));
}

/* Return whether the queue is empty */
bool queueEmpty(Queue *queue) {
    return stackEmpty(&(queue->s1))
        && stackEmpty(&(queue->s2));
}

/* Destroy the queue */
void queueDestroy(Queue *queue) {
    stackDestroy(&(queue->s1));
    stackDestroy(&(queue->s2));
}

int main() {
    Queue q;
    int i;
    int size = 10;

    queueCreate(&q, size);

    for (i = 0; i < size; i++) {
        queuePush(&q, i);
    }

    while (!queueEmpty(&q)) {
        printf("%d\n", queuePeek(&q));
        queuePop(&q);
    }

    queueDestroy(&q);

    return 0;
}
