/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     struct ListNode *next;
 * };
 */
bool hasCycle(struct ListNode *head) {
    if (head == NULL) {
        return false;
    }

    struct ListNode *slow = head;
    struct ListNode *fast = head->next;

    while (fast) {
        if (slow == fast) {
            return true;
        } else {
            slow = slow->next;
            fast = fast->next;
            if (fast == NULL) {
                break;
            }
            fast = fast->next;
        }
    }

    return false;
}
