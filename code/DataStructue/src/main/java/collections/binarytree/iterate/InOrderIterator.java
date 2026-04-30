package collections.binarytree.iterate;

import collections.binarytree.BinaryTreeNode;
import jakarta.annotation.Nullable;

import java.util.Iterator;
import java.util.Stack;

public class InOrderIterator<T, E extends BinaryTreeNode<T, E>> implements Iterator<T>  {
    @Nullable
    E node;
    Stack<E> stack;

    public InOrderIterator(@Nullable E node) {
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
    public T next() {
        E currentNode = stack.pop();
        @Nullable E right = currentNode.getRight();
        if (right != null) {
            stack.push(right);
        }

        return currentNode.getData();
    }
}
