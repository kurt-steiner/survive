package collections.btree;

import jakarta.annotation.Nullable;

import java.util.ArrayList;
import java.util.List;

public class Node<T extends Comparable<T>> {
    @Nullable
    Node<T> parent;

    List<T> items;
    List<Node<T>> children;

    int maxChildrenSize;
    int maxItemsSize;

    public Node(int degree) {
        this.items = new ArrayList<>();
        this.children = new ArrayList<>();

        this.maxItemsSize = degree - 1;
        this.maxChildrenSize = degree;
    }


}
