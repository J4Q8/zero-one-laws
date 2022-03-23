### TUTORIAL: https://www.matecdev.com/posts/julia-tutorial-science-engineering.html

#imports
using LinearAlgebra

#using functions from other files/modules
include("tutorial2.jl")

#You can use unicode!!!
box = '◻'
box_string = "\\mdwhtsquare, \\:white_medium_square:"
diamond = '◇'
diamond_string = "\\mdlgwhtdiamond"
print(box * " can be obtained by " * box_string * "\n")
print(diamond * " can be obtained by" * diamond_string * "\n\n")

θ = π^2
print(θ, "\n\n")

#nested loops, "∈" and "in" are both fine
for i ∈ 1:3, j ∈ 1:3
    print("i=", i, " j=", j, "\n")
end

#defining functions
function sum_series(n)
    x = 0
    for k in 1:n
        x = x + (1/k)^2
    end
    return x
end

#defining functions v2
sum_series2(N) = sum(1/n^2 for n=1:N)

# arguments are not copied! so the function can actually modify their arguments! it is convention to finish such functions with "!"
function add_one!(x)
    x = x + 1
end
x = 3
add_one!(x);

#this apparently copies the variable NEED TO CHECK HOW IS IT WITH STRUCTS!!
function test(x)
    a = x
    a = a + 1
    print(x)
end

#using imports
x = tutorial2.getgoldenration()


#initializing matrix
A = [1 2 3; 1 2 4; 2 2 2] 

b1 = [4.0, 5, 6]                # 3-element Vector{Float64}
b2 = [4.0; 5; 6]                # 3-element Vector{Float64}
m1 = [4.0 5 6]                  # 1×3 Matrix{Float64}

#list comprehension
v = [1/n^2 for n=1:100000]
x = sum(v)

#generator
gen = (1/n^2 for n=1:100000)
x = sum(gen)

#initializing arrays/matrices
n = 5
A1 = Array{Float64}(undef,n,n)          # 5×5 Matrix{Float64}
A2 = Matrix{Float64}(undef,n,n)         # 5×5 Matrix{Float64}

V1 = Array{Float64}(undef,n)            # 5-element Vector{Float64}
V2 = Vector{Float64}(undef,n)            # 5-element Vector{Float64}

A = Array{String}(undef,n)
A = Array{Any}(undef,n)


#empty arrays
v = Array{Float64}(undef,0)
v = Float64[]

#build in solver
b1 = [4.0, 5, 6]                # 3-element Vector{Float64}
b2 = [4.0; 5; 6]                # 3-element Vector{Float64}
m1 = [4.0 5 6]                  # 1×3 Matrix{Float64}

x=A\b1                          # Solves A*x=b
x=A\b2                          # Solves A*x=b  
x=A\m1                          # Error!!

#use . to indicate that you want to apply a function to each element
f(x) = 3x^3/(1+x^2)
x = [2π/n for n=1:30]
y = f.(x)

y = 2x.^2 + 3x.^5 - 2x.^8
y = @. 2x^2 + 3x^5 - 2x^8
