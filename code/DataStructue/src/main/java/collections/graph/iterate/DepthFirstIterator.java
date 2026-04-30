package collections.graph.iterate;

import collections.graph.Edge;
import collections.graph.Graph;
import collections.graph.utils.Colors;
import jakarta.annotation.Nonnull;

import java.util.*;
import java.util.function.Consumer;
import java.util.stream.Stream;
import java.util.stream.StreamSupport;

public class DepthFirstIterator<T> extends GraphIterator<T> implements Spliterator<T> {
    @Nonnull
    public Graph<T> graph;
    @Nonnull
    Stack<T> stack;
    @Nonnull
    Map<T, Colors> visited;

    public DepthFirstIterator(@Nonnull Graph<T> graph) {
        this.graph = graph;
        this.stack = new Stack<>();
        this.visited = new HashMap<>();

        if (graph.countVertex == 0) {
            return;
        }

        graph.adjacentLists.forEach(adjacentList -> {
            T vertex = adjacentList.vertex;
            visited.put(vertex, Colors.White);
        });

        T firstVertex = graph.adjacentLists.getFirst().vertex;
        stack.add(firstVertex);
    }


    @Override
    public boolean hasNext() {
        return !stack.isEmpty();
    }

    @Override
    public T next() {
        T vertex = stack.pop();
        Optional<List<Edge<T>>> oEdges = graph.findEdges(vertex);
        oEdges.ifPresent(edges -> {
            edges.stream()
                    .filter(edge -> visited.get(edge.vertex) == Colors.White)
                    .forEach(edge -> {
                        stack.add(edge.vertex);
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
