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
        TreeMap<Integer, Integer> sorted = new TreeMap<Integer, Integer>();
        for(Integer i : arr) {
            int prev = sorted.containsKey(i) ? sorted.get(i) : 0;
            sorted.put(i, prev + 1);
        }
        Long total = 0L;
        for(Map.Entry<Integer, Integer> entry : sorted.entrySet()) {
            for(int i=0; i < entry.getValue(); i++) {
                total += entry.getKey();
            }
        }
        Long min = total - sorted.lastKey();
        Long max = total - sorted.firstKey();
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

//in:  140638725 436257910 953274816 734065819 362748590
//out: 1673711044 2486347135

//in:  5 5 5 5 5
//out: 20 20
