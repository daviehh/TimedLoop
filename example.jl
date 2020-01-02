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


@tmlv for j = 1:nl
    c[j] = j
    sleep(.1)
    println("looping $j")
end
