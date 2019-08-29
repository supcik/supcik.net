---
title: "How to solve the MONEY problem with Go"
date: 2018-06-04
tags: ['golang', 'algorithm']
---

{{% bbox class="has-background-white-ter" %}}

_(Cet article n'est disponible qu'en anglais / This article is only available in English)_

{{% /bbox %}}

Learning Go could probably help you get a good job, but this is not the subject of this post.
Here we will show you how to solve the classical [verbal arithmetic puzzle,](https://en.wikipedia.org/wiki/Verbal_arithmetic) "SEND + MORE = MONEY".
The goal is to find the mapping between the letters and the digits such that the
addition is correct.

## Data structure

We will use object-oriented style of programming, so we start by defining a
type for the puzzle:

{{< highlight go "linenos=1,linenostart=11" >}}
type verbalSum struct {
    operands []string
    result   string
}
{{< / highlight >}}

This type stores the operands of the addition (e.g. "SEND" and "MORE")
and the result (e.g. "MONEY").

We want to be able to print the puzzle, so we implement the `String` method:

{{< highlight go "linenos=1,linenostart=112" >}}
func (v verbalSum) String() string {
    return strings.Join(v.operands, " + ") + " = " + v.result
}
{{< / highlight >}}

Solving this puzzle actually means to find the correct mapping between the letters and the digits.
In Go, we can simply use  a `map` where the keys are **runes** and the values are **integers**.

When we have a mapping, here is how we can convert a text to the corresponding number:

{{< highlight go "linenos=1,linenostart=16" >}}
func verbToInt(verb string, mapping map[rune]int) int {
    if mapping[[]rune(verb)[0]] == 0 {
        return -1
    }
    result := 0
    for _, c := range []rune(verb) {
        result = result*10 + mapping[c]
    }
    return result
}
{{< / highlight >}}

The test at line 17 returns an error if the resulting number would start with a zero.
It would probably be more elegant to return an error in Go, but this would occur so many
times that the impact on the performance would be too high.

Having this function, we can now easily implement a method that takes a mapping
and returns the numerical representation of the solution:

{{< highlight go "linenos=1,linenostart=116" >}}
func (v verbalSum) solutionString(mapping map[rune]int) string {
    args := make([]string, len(v.operands))
    for i, x := range v.operands {
        n := verbToInt(x, mapping)
        args[i] = strconv.Itoa(n)
    }
    n := verbToInt(v.result, mapping)
    return strings.Join(args, " + ") + " = " + strconv.Itoa(n)
}
{{< / highlight >}}

## Algorithm

The "heart" of the solution is a recursive functions that take 3 arguments:

* A list of letters that are not yet assigned to a digit
* A list of available digits
* The current letter to digit mapping

For statistical purposes, the recursive function returns the number of combinations evaluated and the number of solutions found.

{{< highlight go "linenos=1,linenostart=70" >}}
func (v verbalSum) recursiveSolve(
    letters []rune, digits []int, mapping map[rune]int,
) (combinations int, solutions int) {
    if len(letters) == 0 {
        if v.isValidSolution(mapping) {
            fmt.Printf("Found   %v\n", v.solutionString(mapping))
            return 1, 1 // one solution tried, one solution found
        }
        return 1, 0 // one solution tried, zero solution found
    }
    letter := letters[0] // take the first letter
    combinations, solutions = 0, 0
    for i, digit := range digits { // try all digits for the letter "letter"
        mapping[letter] = digit
        c, s := v.recursiveSolve(letters[1:], withoutItem(digits, i), mapping)
        combinations += c
        solutions += s
    }
    delete(mapping, letter) // backtrack
    return
}
{{< / highlight >}}

The algorithm check first we all letters are assigned to a digit (line 73). If this is the case, we check if the current mapping is valid (line 74) we display the solution.

If we still have unassigned letters, we assigned all remaining digits to the first unassigned letter (lines 80–83) and we call the function recursively (line 84). Then we update the statistics (lines 85–86). Finally, we "backtrack" by removing the handled letter.

Checking if a solution is easy and we re-use our function `verbToInt`:

{{< highlight go "linenos=1,linenostart=54" >}}
func (v verbalSum) isValidSolution(mapping map[rune]int) bool {
    sum := 0
    for _, arg := range v.operands {
        n := verbToInt(arg, mapping)
        if n < 0 {
            return false
        }
        sum += n
    }
    n := verbToInt(v.result, mapping)
    if n < 0 {
        return false
    }
    return sum == n
}
{{< / highlight >}}

When we iterate over the digits, we actually need to remove the current digit
from the set before we go deeper in the recursion. We could have implemented
the digits as a set (using `map[int]bool`), but we decided to rather use slices
here. So here is a function that removes the ith element of a slice of integers:

{{< highlight go "linenos=1,linenostart=27" >}}
func withoutItem(list []int, i int) []int {
    res := make([]int, 0, len(list)-1)
    res = append(res, list[:i]...)
    res = append(res, list[i+1:]...)
    return res
}
{{< / highlight >}}

## The rest of the program

The recursive algorithm is called from the `solve` method. This method collect all letters
from the puzzle and prepares the list of digits. At the end, the method prints the
statistical information.

{{< highlight go "linenos=1,linenostart=92" >}}
func (v verbalSum) solve() error {
    fmt.Printf("Solving %v\n", v)
    // Build a letters array with all letter from all operands and from the result
    letters := v.allLetters()
    // Build a numbers array with all digits from 0 to 9
    digits := make([]int, 10)
    for i := 0; i < 10; i++ {
        digits[i] = i
    }
    if len(letters) > len(digits) {
        return errors.Errorf("Too many letters")
    }

    mapping := make(map[rune]int)
    count, sols := v.recursiveSolve(letters, digits, mapping)
    fmt.Printf("I tried %v combinations\n", count)
    fmt.Printf("I found %v solution(s)\n", sols)
    return nil
}
{{< / highlight >}}

To collect all letters, we use a set and add all characters of the puzzle. Go does
not have *set*, but we can simulate a set with a map (`map[rune]bool`):

{{< highlight go "linenos=1,linenostart=34" >}}
func (v verbalSum) allLetters() []rune {
    letterSet := make(map[rune]bool)
    for _, arg := range v.operands {
        for _, l := range arg {
            letterSet[l] = true
        }
    }
    for _, l := range v.result {
        letterSet[l] = true
    }
    letters := make([]rune, len(letterSet))
    i := 0
    // The order of the letters is not deterministic, but it doesn't matter
    for k := range letterSet {
        letters[i] = k
        i++
    }
    return letters
}
{{< / highlight >}}

Finally, here is the main function that solves the puzzle:

{{< highlight go "linenos=1,linenostart=126" >}}
func main() {
    challenge := verbalSum{
        operands: []string{"SEND", "MORE"},
        result:   "MONEY",
    }

    err := challenge.solve()
    if err != nil {
        fmt.Printf("Error: %v", err)
    }
}
{{< / highlight >}}

## Output

```
Solving SEND + MORE = MONEY
Found   9567 + 1085 = 10652
I tried 1814400 combinations
I found 1 solution(s)
```

## Conclusion

The solution presented here is elegant and efficient. A modern notebook finds the solution of this
puzzle is a little more than 500ms. A a future work, we could implement a multi-thread solution based on the workers models and see if we can do better.

The complete code is available in [github](https://github.com/supcik/money-problem-go).
