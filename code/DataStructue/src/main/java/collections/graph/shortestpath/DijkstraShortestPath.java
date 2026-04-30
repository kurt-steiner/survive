package collections.graph.shortestpath;

import collections.graph.AdjacentList;
import collections.graph.Edge;
import collections.graph.Graph;
import collections.trait.CompareResult;
import jakarta.annotation.Nonnull;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

public class DijkstraShortestPath<T> {
    private static final Distance infinity = new Distance.Infinity();

    @Nonnull
    public Graph<T> graph;
    @Nonnull
    private final T startVertex;
    @Nonnull
    private final Map<T, Distance> distanceMap; // if optional is empty, infinity
    @Nonnull
    private final Map<T, Optional<T>> parents;
    @Nonnull
    private final Map<T, Boolean> visited;

    public DijkstraShortestPath(@Nonnull Graph<T> graph, @Nonnull T startVertex) {
        this.graph = graph;
        this.startVertex = startVertex;
        this.distanceMap = new HashMap<>();
        this.parents = new HashMap<>();
        this.visited = new HashMap<>();

        compute();
    }


    private void compute() {
        // initialize
        for (AdjacentList<T> adjacentList: graph.adjacentLists) {
            distanceMap.put(adjacentList.vertex, infinity);
            parents.put(adjacentList.vertex, Optional.empty());
            visited.put(adjacentList.vertex, false);
        }

        distanceMap.put(startVertex, new Distance.Value(0));

        while (true) {
            Optional<AdjacentList<T>> oMinAdjacentList = minAdjacentListUnvisited();
            if (oMinAdjacentList.isEmpty()) { // also means, all visited
                break;
            }

            AdjacentList<T> minAdjacentList = oMinAdjacentList.get();
            T minVertex = minAdjacentList.vertex;
            List<Edge<T>> edges = minAdjacentList.edges;

            for (Edge<T> edge: edges) {
                // here
                Distance distanceAcc = distanceMap.get(minVertex)
                        .plus(edge.weight);

                Distance distanceToEdgeVertex = distanceMap.get(edge.vertex);
                if (distanceToEdgeVertex.compare(distanceAcc) == CompareResult.Greater) {
                    distanceMap.put(edge.vertex, distanceAcc);
                    parents.put(edge.vertex, Optional.of(minVertex));
                }
            }

            // update
            visited.put(minVertex, true);
        }
    }

    private Optional<AdjacentList<T>> minAdjacentListUnvisited() {
        return graph.adjacentLists.stream()
                .filter(adjacentList -> !visited.get(adjacentList.vertex))
                .reduce((left, right) -> {
                    T vertexLeft = left.vertex;
                    T vertexRight = right.vertex;

                    Distance distanceToLeft = distanceMap.get(vertexLeft);
                    Distance distanceToRight = distanceMap.get(vertexRight);

                    if (distanceToLeft.equals(infinity)) {
                        return right;
                    }

                    if (distanceToRight.equals(infinity)) {
                        return left;
                    }


                    if (distanceToLeft.compare(distanceToRight) == CompareResult.Less) {
                        return left;
                    } else {
                        return right;
                    }
                });
    }

    @Override
    public String toString() {
        return super.toString();
    }
}
