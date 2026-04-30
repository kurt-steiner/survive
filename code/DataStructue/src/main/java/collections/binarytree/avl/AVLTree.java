package collections.binarytree.avl;

import collections.binarytree.iterate_node.InOrderNodeIterator;
import jakarta.annotation.Nonnull;
import jakarta.annotation.Nullable;

import java.util.Objects;
import java.util.Optional;
import java.util.function.Predicate;

public class AVLTree<T extends Comparable<T>> {
    @Nullable
    TreeNode<T> root;
    int size = 0;

    public AVLTree() {
        this.root = null;
        this.size = 0;
    }

    public void insert(@Nonnull T data) {
        this.root = insertNode(this.root, data);
        this.size += 1;
    }

    public void remove(@Nonnull T data) {
        @Nullable TreeNode<T> deleteNode = findNode(data);
        if (deleteNode == null) {
            return;
        }

        // 普通的 BST 删除
        @Nullable TreeNode<T> parent = deleteNode.parent;

        if (deleteNode.isLeaf()) { // 叶子节点
            if (parent == null) { // 根节点
                this.root = null;
            } else if (parent.left == deleteNode) {
                parent.left = null;
                parent.updateHeight();
            } else { // parent.right == deleteNode
                parent.right = null;
                parent.updateHeight();
            }
        } else if (deleteNode.left != null && deleteNode.right == null) { // 只有左子树
            if (parent == null) {
                this.root = deleteNode.left;
                this.root.updateHeight();
            } else if (parent.left == deleteNode) {
                parent.left = deleteNode.left;
                parent.updateHeight();
            } else { // parent.right == deleteNode
                parent.right = deleteNode.left;
                parent.updateHeight();
            }
        } else if (deleteNode.left == null && deleteNode.right != null) { // 只有右子树
            if (parent == null) {
                this.root = deleteNode.right;
                this.root.updateHeight();
            } else if (parent.left == deleteNode) {
                parent.left = deleteNode.right;
                parent.updateHeight();
            } else {
                parent.right = deleteNode.right;
                parent.updateHeight();
            }
        } else { // 左右子树都有
            InOrderNodeIterator<T, TreeNode<T>> inOrder = new InOrderNodeIterator<>(deleteNode.right);
            TreeNode<T> minNode = inOrder.next();

            minNode.left = deleteNode.left;
            minNode.right = deleteNode.right;
            minNode.updateHeight();

            if (parent == null) {
                this.root = minNode;
            } else if (parent.left == deleteNode) {
                parent.left = minNode;
            } else { // parent.right == deleteNode
                parent.right = minNode;
            }

            // 向上回溯，更新高度
            TreeNode<T> parentOfMinNode = Objects.requireNonNull(minNode.parent);
            if (parentOfMinNode.left == minNode) {
                parentOfMinNode.left = null;
            } else {
                parentOfMinNode.right = null;
            }

            @Nullable TreeNode<T> currentNode = parentOfMinNode;
            while (currentNode != null) {
                currentNode.updateHeight();
                currentNode = currentNode.parent;
            }
        }

        this.size -= 1;

        // 现在开始 AVL 调整
        @Nullable TreeNode<T> unBalancedNode = parent;
        while (unBalancedNode != null) {
            if (Math.abs(TreeNode.balanceFactor(unBalancedNode)) > 1) {
                break;
            }

            unBalancedNode = unBalancedNode.parent;
        }

        if (unBalancedNode == null) {
            return;
        }

        // nodeY: unBalanceNode 左右节点中，高度最高的节点
        @Nullable TreeNode<T> nodeY = null;
        Objects.requireNonNull(unBalancedNode.left);
        Objects.requireNonNull(unBalancedNode.right);

        if (unBalancedNode.left.height > unBalancedNode.right.height) {
            nodeY = unBalancedNode.left;
        } else {
            nodeY = unBalancedNode.right;
        }

        // nodeX: nodeY 左右节点中，高度最高的节点
        Objects.requireNonNull(nodeY.left);
        Objects.requireNonNull(nodeY.right);

        @Nullable TreeNode<T> nodeX = null;
        if (nodeY.left.height > nodeY.right.height) {
            nodeX = nodeY.left;
        } else {
            nodeX = nodeY.right;
        }

        @Nullable TreeNode<T> parentOfUnbalancedNode = unBalancedNode.parent;
        // 调整 parent of unbalance node
        @Nullable TreeNode<T> adjustedNode = null;
        if (unBalancedNode.left == nodeY && nodeY.left == nodeX) {
            adjustedNode = unBalancedNode.rotateLeftLeft();
        } else if (unBalancedNode.left == nodeY && nodeY.right == nodeX) {
            adjustedNode = unBalancedNode.rotateLeftRight();
        } else if (unBalancedNode.right == nodeY && nodeY.right == nodeX) {
            adjustedNode = unBalancedNode.rotateRightRight();
        } else if (unBalancedNode.right == nodeY && nodeY.left == nodeX) {
            adjustedNode = unBalancedNode.rotateRightLeft();
        }

        if (parentOfUnbalancedNode == null) {
            this.root = adjustedNode;
        } else {
            if (parentOfUnbalancedNode.left == unBalancedNode) {
                parentOfUnbalancedNode.left = adjustedNode;
            } else {
                parentOfUnbalancedNode.right = adjustedNode;
            }
        }
    }

    @Nonnull
    private TreeNode<T> insertNode(@Nullable TreeNode<T> node, @Nonnull T data) {
        if (node == null) {
            return new TreeNode<>(data);
        }

        int compareResult = data.compareTo(node.data);
        if (compareResult >= 0) {
            node.setRight(insertNode(node.right, data));
        } else {
            node.setLeft(insertNode(node.left, data));
        }

        node.updateHeight();
        // rebalance
        return node.rebalance();
    }

    @Nullable
    private TreeNode<T> findNode(@Nonnull T data) {
        @Nullable TreeNode<T> currentNode = this.root;

        while (currentNode != null) {
            int compareResult = data.compareTo(currentNode.data);
            if (compareResult < 0) {
                currentNode = currentNode.left;
            } else if (compareResult > 0) {
                currentNode = currentNode.right;
            } else {
                return currentNode;
            }
        }

        return null;
    }
}
