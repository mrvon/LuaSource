/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     struct TreeNode *left;
 *     struct TreeNode *right;
 * };
 */
struct TreeNode* lowestCommonAncestor(struct TreeNode* root, struct TreeNode* p, struct TreeNode* q) {
    if (root == NULL) {
        return NULL;
    }
    
    if (p->val <= root->val && q->val >= root->val) {
        // p, q in the different subtree
        return root;
    } else if (p->val >= root->val && q->val <= root->val) {
        // p, q in the different subtree
        return root;
    } else if (p->val <= root->val) {
        // p, q in the the same subtee(left)
        return lowestCommonAncestor(root->left, p, q);
    } else {
        // p, q in the the same subtee(right)
        return lowestCommonAncestor(root->right, p, q);
    }
}
