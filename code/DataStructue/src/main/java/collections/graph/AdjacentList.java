package collections.graph;

import jakarta.annotation.Nonnull;

import java.util.LinkedList;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

public class AdjacentList<T> {
    @Nonnull
    public T vertex;
    @Nonnull
    public List<Edge<T>> edges;

    private AdjacentList(@Nonnull T vertex, @Nonnull List<Edge<T>> edges) {
        this.vertex = vertex;
        this.edges = edges;
    }

    public AdjacentList(@Nonnull T vertex) {
        this(vertex, new LinkedList<>());
    }

    @Override
    public boolean equals(Object o) {
        if (o == null || getClass() != o.getClass()) return false;
        AdjacentList<?> that = (AdjacentList<?>) o;
        return Objects.equals(vertex, that.vertex) && Objects.equals(edges, that.edges);
    }

    @Override
    public int hashCode() {
        return Objects.hash(vertex, edges);
    }

    @Override
    public String toString() {
        String pattern = "%s | %s";
        String left = this.vertex.toString();
        String right = this.edges.stream().map(Edge::toString).collect(Collectors.joining(", "));
        return String.format(pattern, left, right);
    }
}
