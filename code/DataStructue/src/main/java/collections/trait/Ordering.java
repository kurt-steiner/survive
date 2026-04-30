package collections.trait;

import jakarta.annotation.Nonnull;

public interface Ordering<T> {
    @Nonnull
    CompareResult compare(@Nonnull T other);
}
