package com.steiner.sort;

public class QuickSort {
    public static void quickSort(int [] numbers) {
        quickSort(numbers, 0, numbers.length - 1);
    }

    private static void quickSort(int [] numbers, int left, int right) {
        if (left < right) {
            int pivotPosition = partition(numbers, 0, numbers.length - 1);
            quickSort(numbers, left, pivotPosition - 1);
            quickSort(numbers, pivotPosition + 1, right);
        }
    }


    private static int partition(int[] numbers, int left, int right) {
        int pivot = numbers[left];

        while (left < right) {
            while (left < right && numbers[right] >= pivot) {
                right -= 1;
            }

            numbers[left] = numbers[right];

            while (left < right && numbers[left] <= pivot) {
                left += 1;
            }

            numbers[right] = numbers[left];
        }

        // when left == right
        numbers[left] = pivot;
        return left;
    }
}
