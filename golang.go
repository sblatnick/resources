package main

import (
  "fmt"
  "math"
)

//Type comes after variable:
func add(x int, y int) int {
  return x + y
}

func main() {
  fmt.Println(add(42, math.Pi)) //exported variables must be capitalized: Pi vs pi
}


x int    //int
p *int   //int pointer
a [3]int //int array



var a []int
x = a[1]


var p *int
x = *p

