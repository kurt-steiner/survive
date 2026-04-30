package collections.graph;

import jakarta.annotation.Nonnull;

public class Errors {
    @Nonnull
    public static <T> GraphError DuplicateVertex(@Nonnull T vertex) {
        String message = "节点 '%s' 是重复";
        return new GraphError(String.format(message, vertex));
    }

    @Nonnull
    public static <T> GraphError DuplicateEdge(@Nonnull T vertexOfEdge) {
        String message = "边上的节点 '%s' 是重复的";
        return new GraphError(String.format(message, vertexOfEdge));
    }

    @Nonnull
    public static <T> GraphError MissingVertex(@Nonnull T vertex) {
        String message = "节点 '%s' 缺失";
        return new GraphError(String.format(message, vertex));
    }

    public static final GraphError UnmatchedVertex = new GraphError("找不到匹配这个predicate的节点");

}
