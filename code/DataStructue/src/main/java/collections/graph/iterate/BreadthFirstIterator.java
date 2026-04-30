package collections.graph.iterate;

import collections.graph.Edge;
import collections.graph.Graph;
import collections.graph.utils.Colors;
import jakarta.annotation.Nonnull;

import java.util.*;
import java.util.function.Consumer;
import java.util.stream.Stream;
import java.util.stream.StreamSupport;

public class BreadthFirstIterator<T> extends GraphIterator<T> implements Spliterator<T> {
    @Nonnull
    public Graph<T> graph;
    @Nonnull
    Queue<T> queue;
    @Nonnull
    Map<T, Colors> visited;

    public BreadthFirstIterator(@Nonnull Graph<T> graph) {
        this.graph = graph;
        this.queue = new LinkedList<>();
        this.visited = new HashMap<>();

        if (graph.countVertex == 0) {
            return;
        }

        graph.adjacentLists.forEach(adjacentList -> {
            T vertex = adjacentList.vertex;
            visited.put(vertex, Colors.White);
        });

        T firstVertex = graph.adjacentLists.getFirst().vertex;
        queue.add(firstVertex);
    }

    @Override
    public boolean hasNext() {
        return !queue.isEmpty();
    }

    @Override
    public T next() {
        T vertex = queue.remove();
        Optional<List<Edge<T>>> oEdges = graph.findEdges(vertex);

        oEdges.ifPresent(edges -> {
            edges.stream()
                    .filter(edge -> visited.get(edge.vertex) == Colors.White)
                    .forEach(edge -> {
                        queue.add(edge.vertex);
                        visited.put(edge.vertex, Colors.Grey);
                    });
        });

        // update visited
        visited.put(vertex, Colors.Black);
        return vertex;
    }

    @Nonnull
    @Override
    public Stream<T> stream() {
        return StreamSupport.stream(this, false);
    }

    @Override
    public boolean tryAdvance(Consumer<? super T> consumer) {
        boolean hasNext = this.hasNext();

        if (hasNext) {
            consumer.accept(this.next());
        }

        return hasNext;
    }

    @Override
    public Spliterator<T> trySplit() {
        return null;
    }

    @Override
    public long estimateSize() {
        return this.graph.countVertex;
    }

    @Override
    public int characteristics() {
        return Spliterator.ORDERED | Spliterator.IMMUTABLE;
    }

    @Override
    public void forEachRemaining(Consumer<? super T> action) {
        while (hasNext()) {
            action.accept(next());
        }
    }
}
