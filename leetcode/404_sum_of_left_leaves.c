/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     struct TreeNode *left;
 *     struct TreeNode *right;
 * };
 */
int sumOfLeftLeaves(struct TreeNode* root) {
    if (root == NULL) {
        // NULL NODE
        return 0;
    } else if (root->left == NULL && root->right == NULL) {
        // A LEAVES
        return 0;
    } else {
        int sum = 0;
        // NOT A LEAVES
        if (root->left && root->left->left == NULL && root->left->right == NULL) {
            // LEFT CHILD IS LEAVES
            sum += root->left->val;
        } else {
            sum += sumOfLeftLeaves(root->left);
        }
        sum += sumOfLeftLeaves(root->right);
        return sum;
    }
}
