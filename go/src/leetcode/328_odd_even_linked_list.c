/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     struct ListNode *next;
 * };
 */
struct ListNode* oddEvenList(struct ListNode* head) {
    if (head == NULL) {
        return head;
    }
    
    struct ListNode* head_odd = head;
    struct ListNode* head_even = head->next;
    struct ListNode* end_odd = head_odd;
    struct ListNode* end_even = head_even;
    struct ListNode* next_odd;
    struct ListNode* next_even;
    
    while (end_even && end_even->next) {
        next_odd = end_even->next;
        end_odd->next = next_odd;
        end_odd = next_odd;
        if (end_odd) {
            next_even = end_odd->next;
            end_even->next = next_even;
            end_even = next_even;
        }
    }
    
    end_odd->next = head_even;
    
    return head;
}
