package collections.graph;

import jakarta.annotation.Nonnull;

import java.util.Objects;

public class Edge<T> {
    @Nonnull
    public T vertex;
    public int weight;


    public Edge(@Nonnull T vertex, int weight) {
        this.vertex = vertex;
        this.weight = weight;
    }

    @Override
    public boolean equals(Object o) {
        if (o == null || getClass() != o.getClass()) return false;
        Edge<?> edge = (Edge<?>) o;
        return weight == edge.weight && Objects.equals(vertex, edge.vertex);
    }

    @Override
    public int hashCode() {
        return Objects.hash(vertex, weight);
    }

    @Override
    public String toString() {
        String pattern = "(%s, %d)";
        return String.format(pattern, this.vertex, this.weight);
    }
}
