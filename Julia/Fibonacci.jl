#Method 1 - Function

function fibo(n::Int64)
    a = 0
    b = 1
    if n < 0
        print("Incorrect Input")
    elseif n == 0
        return a
    elseif n == 1
        return b
    elseif n>1
        for i in 2:n
            c = a + b
            a = b
            b = c
    end
        return b
    end
end

#Method 1 - Macro

macro fibo(n::Int64)
    a = 0
    b = 1
    if n < 0
        print("Incorrect Input")
    elseif n == 0
        return a
    elseif n == 1
        return b
    elseif n>1
        for i in 2:n
            c = a + b
            a = b
            b = c
    end
        return b
    end
end

#Method 2 - Function

function fibo(n::Int64)
     
    f = [0,1]
    if n < 0
        print("The input must be equal to or bigger than zero.") 
    else  
    for i in 3:n+1
        push!(f, f[i-1] + f[i-2])
        end
    end
    print(f[n+1])
end

#Method 2 - Macro 

macro fibo(n::Int64)
     
    f = [0,1]
    if n < 0
        print("The input must be equal to or bigger than zero.") 
    else  
    for i in 3:n+1
        push!(f, f[i-1] + f[i-2])
        end
    end
    print(f[n+1])
end




