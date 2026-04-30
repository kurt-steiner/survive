package collections.graph.iterate;

import jakarta.annotation.Nonnull;

import java.util.Iterator;
import java.util.stream.Stream;

public abstract class GraphIterator<T> implements Iterator<T> {
    @Nonnull
    public abstract Stream<T> stream();
}