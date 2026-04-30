package collections.graph.shortestpath;

import collections.trait.CompareResult;
import collections.trait.Ordering;
import jakarta.annotation.Nonnull;

public abstract class Distance implements Ordering<Distance> {
    public abstract Distance plus(int weight);

    public static class Infinity extends Distance {
        @Override
        public Distance plus(int weight) {
            return this;
        }

        @Nonnull
        @Override
        public CompareResult compare(@Nonnull Distance other) {
            return CompareResult.Greater;
        }
    }

    public static class Value extends Distance {
        public int value;

        public Value(int value) {
            this.value = value;
        }

        @Override
        public Distance plus(int weight) {
            return new Value(this.value + weight);
        }


        @Nonnull
        @Override
        public CompareResult compare(@Nonnull Distance other) {
            if (other instanceof Infinity) {
                return CompareResult.Less;
            }

            if (other instanceof Value otherValue) {
                int result = this.value - otherValue.value;

                if (result < 0) {
                    return CompareResult.Less;
                } else if (result == 0) {
                    return CompareResult.Equal;
                } else {
                    return CompareResult.Greater;
                }
            }

            throw new IllegalArgumentException("unexpected value of " + other.toString());
        }
    }
}
