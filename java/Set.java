import java.io.*;
import java.math.*;
import java.security.*;
import java.text.*;
import java.util.*;
import java.util.concurrent.*;
import java.util.function.*;
import java.util.regex.*;
import java.util.stream.*;
import static java.util.stream.Collectors.joining;
import static java.util.stream.Collectors.toList;

class Result {

/*
 * Hackerrank Challenge
 * Given five positive integers, find the minimum and maximum values 
 * that can be calculated by summing exactly four of the five integers.
 */
    public static void miniMaxSum(List<Integer> arr) {
        TreeSet<Integer> sorted = new TreeSet<Integer>();
        for(Integer i : arr) {
             sorted.add(i);
        }
        Long total = 0L;
        for(Integer i : sorted) {
            total += i;
        }
        Integer[] array = sorted.toArray(new Integer[sorted.size()]);
        Long min = total - array[sorted.size() - 1];
        Long max = total - array[0];
        System.out.println(min + " " + max);
    }

}

public class Solution {
    public static void main(String[] args) throws IOException {
        BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(System.in));

        List<Integer> arr = Stream.of(bufferedReader.readLine().replaceAll("\\s+$", "").split(" "))
            .map(Integer::parseInt)
            .collect(toList());

        Result.miniMaxSum(arr);

        bufferedReader.close();
    }
}

//140638725 436257910 953274816 734065819 362748590
//1673711044 2486347135
