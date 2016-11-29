/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     struct TreeNode *left;
 *     struct TreeNode *right;
 * };
 */
bool isSameTree(struct TreeNode* p, struct TreeNode* q) {
    if (p == NULL && q == NULL) {
        return true;
    } else if (p != NULL && q != NULL) {
        return isSameTree(p->left, q->left) &&
            isSameTree(p->right, q->right) &&
            (p->val == q->val);
    } else {
        return false;
    }
}
