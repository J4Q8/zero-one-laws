module tutorial2

export secant, getgoldenration

function secant(f,a,b,rtol,maxIters)
    iter = 0
    while abs(b-a) > rtol*abs(b) && iter < maxIters
        c,a = a,b
        b = b + (b-c)/(f(c)/f(b)-1)
        iter = iter + 1
    end
    return b
end

function getgoldenration()
    ϕ = secant( x-> x^2 - x - 1, 1, 2, 1e-15, 10 )
    return ϕ
end