package collections.binarytree.avl;

import collections.binarytree.BinaryTreeNode;
import jakarta.annotation.Nonnull;
import jakarta.annotation.Nullable;

import java.util.Objects;

public class TreeNode<T> implements BinaryTreeNode<T, TreeNode<T>> {
    public static int height(@Nullable TreeNode<?> node) {
        if (node == null) {
            return 0;
        } else {
            return node.height;
        }
    }

    public static int balanceFactor(@Nullable TreeNode<?> node) {
        if (node == null) {
            return 0;
        }

        return height(node.left) - height(node.right);
    }

    @Nonnull
    public T data;
    @Nullable
    TreeNode<T> left;
    @Nullable
    TreeNode<T> right;

    int height;
    @Nullable
    TreeNode<T> parent;

    public TreeNode(@Nonnull T data) {
        this.data = data;
        this.left = null;
        this.right = null;
        this.parent = null;
        this.height = 1;
    }

    @Nonnull
    public TreeNode<T> rebalance() {
        int factor = balanceFactor(this);
        int leftFactor = balanceFactor(this.left);
        int rightFactor = balanceFactor(this.right);

        if (factor > 1) { // 左边不平衡
            if (leftFactor > 0) { // 左子树的左子树
                return this.rotateLeftLeft();
            } else {              // 左子树的右子树
                return this.rotateLeftRight();
            }
        } else if (factor < -1) {
            if (rightFactor > 0) { // 右子树的左子树
                return this.rotateRightLeft();
            } else {               // 右子树的右子树
                return this.rotateRightRight();
            }
        } else {
            return this;
        }
    }


    @Nonnull
    public TreeNode<T> rotateLeftLeft() {
        TreeNode<T> leftChild = Objects.requireNonNull(this.left);
        @Nullable TreeNode<T> rightChild = leftChild.right;

        this.setLeft(rightChild);
        leftChild.setRight(this);

        this.updateHeight();
        leftChild.updateHeight();

        return leftChild;
    }

    @Nonnull
    public TreeNode<T> rotateRightRight() {
        TreeNode<T> rightChild = Objects.requireNonNull(this.right);
        @Nullable TreeNode<T> leftChild = rightChild.left;
        this.setRight(leftChild);
        rightChild.setLeft(this);

        this.updateHeight();
        rightChild.updateHeight();

        return rightChild;
    }

    @Nonnull
    public TreeNode<T> rotateLeftRight() {
        Objects.requireNonNull(this.left);
        this.setLeft(this.left.rotateRightRight());
        return this.left.rotateLeftLeft();
    }

    @Nonnull
    public TreeNode<T> rotateRightLeft() {
        Objects.requireNonNull(this.right);
        this.setRight(this.right.rotateLeftLeft());
        return this.right.rotateRightRight();
    }

    @Nonnull
    @Override
    public T getData() {
        return this.data;
    }

    @Nullable
    @Override
    public TreeNode<T> getLeft() {
        return this.left;
    }

    @Nullable
    @Override
    public TreeNode<T> getRight() {
        return this.right;
    }

    @Override
    public boolean isLeaf() {
        return left == null && right == null;
    }

    public void updateHeight() {
        this.height = Math.max(height(this.left), height(this.right)) + 1;
    }

    public void setLeft(@Nullable TreeNode<T> child) {
        this.left = child;

        if (child != null) {
            child.parent = this;
        }

    }

    public void setRight(@Nullable TreeNode<T> child) {
        this.right = child;
        if (child != null) {
            child.parent = this;
        }
    }
}
