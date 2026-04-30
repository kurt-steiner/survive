package collections.graph;

import collections.graph.iterate.BreadthFirstIterator;
import collections.graph.iterate.DepthFirstIterator;
import jakarta.annotation.Nonnull;

import java.util.LinkedList;
import java.util.List;
import java.util.Optional;
import java.util.function.Predicate;

public class Graph<T> {
    public static <T> Graph<T> withDirection() {
        return new Graph<>(new LinkedList<>(), true, 0, 0);
    }

    public static <T> Graph<T> withoutDirection() {
        return new Graph<>(new LinkedList<>(), false, 0, 0);
    }

    @Nonnull
    public List<AdjacentList<T>> adjacentLists;
    public boolean hasDirection;
    public int countVertex;
    public int countEdge;

    private Graph(@Nonnull List<AdjacentList<T>> adjacentLists, boolean hasDirection, int countVertex, int countEdge) {
        this.adjacentLists = adjacentLists;
        this.hasDirection = hasDirection;
        this.countVertex = countVertex;
        this.countEdge = countEdge;
    }

    public void addVertex(@Nonnull T vertex) {
        boolean exists = this.adjacentLists
                .stream()
                .anyMatch(adjacentList -> adjacentList.vertex.equals(vertex));

        if (exists) {
            throw Errors.DuplicateVertex(vertex);
        }

        this.adjacentLists.add(new AdjacentList<>(vertex));
        // update
        this.countVertex += 1;
    }

    public void addEdge(@Nonnull T vertex, @Nonnull T otherVertex, int weight) {
        this.addEdge(v -> v.equals(vertex), otherVertex, weight);
    }

    public void addEdge(@Nonnull Predicate<T> predicate, @Nonnull T otherVertex, int weight) {
        AdjacentList<T> adjacentListVertex = this.adjacentLists
                .stream()
                .filter(adjacentList -> predicate.test(adjacentList.vertex))
                .findFirst()
                .orElseThrow(() -> Errors.UnmatchedVertex);


        AdjacentList<T> adjacentListOtherVertex = this.adjacentLists
                .stream()
                .filter(adjacentList -> adjacentList.vertex.equals(otherVertex))
                .findFirst()
                .orElseThrow(() -> Errors.MissingVertex(otherVertex));

        T vertex = adjacentListVertex.vertex;

        // 查询重复
        boolean existsEdgeToOtherV = adjacentListVertex.edges
                .stream()
                .anyMatch(edge -> edge.vertex.equals(otherVertex));

        if (existsEdgeToOtherV) {
            throw Errors.DuplicateEdge(otherVertex);
        }

        adjacentListVertex.edges.add(new Edge<>(otherVertex, weight));

        if (!hasDirection) {
            boolean existsEdgeToV = adjacentListOtherVertex.edges
                    .stream()
                    .anyMatch(edge -> edge.vertex.equals(vertex));
            if (existsEdgeToV) {
                throw Errors.DuplicateEdge(vertex);
            }

            adjacentListOtherVertex.edges.add(new Edge<>(adjacentListVertex.vertex, weight));
        }

        // update
        this.countEdge += 1;
    }

    public void removeVertex(@Nonnull T vertex) {
        this.removeVertex(v -> v.equals(vertex));
    }

    public void removeVertex(@Nonnull Predicate<T> predicate) {
        AdjacentList<T> adjacentList = this.adjacentLists
                .stream()
                .filter(adj -> predicate.test(adj.vertex))
                .findFirst()
                .orElseThrow(() -> Errors.UnmatchedVertex);

        this.countEdge -= adjacentList.edges.size();
        this.adjacentLists.remove(adjacentList);
        // update
        this.countVertex -= 1;

        // update other adjacentList
        this.adjacentLists.forEach(otherAdjacentList -> {
            Predicate<Edge<T>> predicateEdge = edge -> edge.vertex.equals(adjacentList.vertex);
            List<Edge<T>> matchedEdges = otherAdjacentList.edges
                    .stream()
                    .filter(predicateEdge)
                    .toList();

            this.countEdge -= matchedEdges.size();
            otherAdjacentList.edges.removeIf(predicateEdge);
        });
    }

    public void removeEdge(@Nonnull T vertex, @Nonnull T otherVertex) {
        this.removeEdge(left -> left.equals(vertex), right -> right.equals(otherVertex));
    }

    public void removeEdge(@Nonnull Predicate<T> predicateOfVertex, @Nonnull Predicate<T> predicateOfOtherVertex) {
        AdjacentList<T> adjacentListVertex = this.adjacentLists
                .stream()
                .filter(adj -> predicateOfVertex.test(adj.vertex))
                .findFirst()
                .orElseThrow(() -> Errors.UnmatchedVertex);

        AdjacentList<T> adjacentListOtherVertex = this.adjacentLists
                .stream()
                .filter(adj -> predicateOfOtherVertex.test(adj.vertex))
                .findFirst()
                .orElseThrow(() -> Errors.UnmatchedVertex);

        T vertex = adjacentListVertex.vertex;
        T otherVertex = adjacentListOtherVertex.vertex;

        adjacentListVertex.edges.removeIf(edge -> edge.vertex.equals(otherVertex));

        if (!hasDirection) {
            adjacentListOtherVertex.edges.removeIf(edge -> edge.vertex.equals(vertex));
        }

        // update
        this.countEdge -= 1;
    }

    // Iterate
    @Nonnull
    public DepthFirstIterator<T> dfs() {
        return new DepthFirstIterator<>(this);
    }

    @Nonnull
    public BreadthFirstIterator<T> bfs() {
        return new BreadthFirstIterator<>(this);
    }

    // utils
    @Nonnull
    public Optional<List<Edge<T>>> findEdges(@Nonnull T vertex) {
        return this.adjacentLists
                .stream()
                .filter(adjacentList -> adjacentList.vertex.equals(vertex))
                .map(adjacentList -> adjacentList.edges)
                .findFirst();
    }

    @Nonnull
    public Optional<List<Edge<T>>> findEdges(@Nonnull Predicate<T> predicate) {
        return this.adjacentLists
                .stream()
                .filter(adjacentList -> predicate.test(adjacentList.vertex))
                .map(adjacentList -> adjacentList.edges)
                .findFirst();
    }

    @Override
    public String toString() {
        StringBuilder stringBuilder = new StringBuilder();

        stringBuilder.append(String.format("hasDirection: %s\n", hasDirection))
                .append(String.format("count edge: %s\n", countEdge))
                .append(String.format("count vertex: %s\n", countVertex));

        this.adjacentLists.forEach(adjacentList -> {
            stringBuilder.append(adjacentList.toString())
                    .append("\n");
        });

        return stringBuilder.toString();
    }
}
