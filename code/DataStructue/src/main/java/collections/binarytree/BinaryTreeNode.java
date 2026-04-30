package collections.binarytree;

import jakarta.annotation.Nonnull;
import jakarta.annotation.Nullable;

public interface BinaryTreeNode<T, E extends BinaryTreeNode<T, E>> {
    @Nonnull
    T getData();
    @Nullable
    E getLeft();
    @Nullable
    E getRight();

    boolean isLeaf();
}
