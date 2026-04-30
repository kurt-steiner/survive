package collections.binarytree.iterate_node;

import collections.binarytree.BinaryTreeNode;
import jakarta.annotation.Nullable;

import java.util.Iterator;
import java.util.Stack;

public class InOrderNodeIterator<T, E extends BinaryTreeNode<T, E>> implements Iterator<E> {
    @Nullable
    E node;
    Stack<E> stack;

    public InOrderNodeIterator(@Nullable E node) {
        this.node = node;
        this.stack = new Stack<>();

        E currentNode = this.node;
        while (currentNode != null) {
            stack.push(currentNode);
            currentNode = currentNode.getLeft();
        }
    }

    @Override
    public boolean hasNext() {
        return !stack.isEmpty();
    }

    @Override
    public E next() {
        E currentNode = stack.pop();
        @Nullable E right = currentNode.getRight();
        if (right != null) {
            stack.push(right);
        }

        return currentNode;
    }
}
