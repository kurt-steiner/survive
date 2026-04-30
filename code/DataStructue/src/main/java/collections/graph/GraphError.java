package collections.graph;

public class GraphError extends RuntimeException {
    public GraphError(String message) {
        super(message);
    }

    public GraphError(String message, Throwable cause) {
        super(message, cause);
    }
}
