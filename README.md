# Timed for loop

For long-running `for` loops where each loop takes approximately the same time to run, this macro calculates the average time per iteration and estimates when the loop will finish.

- Usage:

  ```julia
  @tml [verbose]
  ```

  `verbose` is an optional Boolean controlling if the output should be verbose:

  - `false` (default): only print the timing information for the first 10 iterations, then every 10 iterations; or if the average per-iteration run time is more than 5 seconds
  - `true`: print timing information every iteration; shortcut `@tmlv`

- example (see example.jl)/TLDR:

  ```julia
  using TimedLoop

  nl = 20
  c = rand(nl)

  @tml for j = 1:nl
      c[j] = j
      sleep(.1)
      println("looping $j")
  end


  @tml true for j = 1:nl
      c[j] = j
      sleep(.1)
      println("looping $j")
  end

  # equivalently
  @tmlv for j = 1:nl
       c[j] = j
       sleep(.1)
       println("looping $j")
   end

  ```
