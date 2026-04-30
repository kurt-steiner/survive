package collections;

import collections.graph.Graph;
import collections.graph.shortestpath.DijkstraShortestPath;
import org.junit.jupiter.api.Test;

public class TestGraph {
    @Test
    public void testGraph() {
        Graph<Integer> graph = Graph.withoutDirection();
        for (int value = 1; value <= 6; value += 1) {
            graph.addVertex(value);
        }

        graph.addEdge(1, 2, 0);
        graph.addEdge(1, 4, 0);
        graph.addEdge(2, 3, 0);
        graph.addEdge(3, 6, 0);
        graph.addEdge(2, 5, 0);
        graph.addEdge(4, 5, 0);
        graph.addEdge(5, 6, 0);
        graph.addEdge(1,6, 0);

        // may throws
        // graph.addEdge(1,6, 0);

        System.out.println(graph.toString());
    }

    @Test
    public void testTraverse() {
        Graph<Integer> graph = fakeGraph();
        graph.bfs().stream()
                .forEach(System.out::println);

        graph.dfs().stream()
                .forEach(System.out::println);
    }

    @Test
    public void testDijkstra() {
        Graph<Integer> graph = fakeGraph();
        DijkstraShortestPath<Integer> shortestPath = new DijkstraShortestPath<>(graph, 1);

    }

    private Graph<Integer> fakeGraph() {
        Graph<Integer> graph = Graph.withDirection();
        for (int value = 1; value <= 5; value += 1) {
            graph.addVertex(value);
        }

        graph.addEdge(1, 2, 10);
        graph.addEdge(1, 5, 5);
        graph.addEdge(2, 5, 2);
        graph.addEdge(2, 3, 1);
        graph.addEdge(3, 4, 4);
        graph.addEdge(4, 1, 7);
        graph.addEdge(4, 3, 6);
        graph.addEdge(5, 3, 9);
        graph.addEdge(5, 2, 3);
        graph.addEdge(5, 4, 2);

        return graph;
    }
}
