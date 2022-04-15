function f(n::Int64)
    f = 1
    if n < 0
        print("Factorial does not exist for negative numbers")
    end
     if n == 0
        print("The factorial of 0 is 1")
     end
     if n>0
        for i in 1:n
            f = f*i
        end
        println("The factorial is: ",f)
    end
end
