# load a file from my computer
using Images

begin
    colored_line(x::Vector) = hcat(Gray.(Float64.(x)))'
    colored_line(x::Any) = nothing
end

colored_line(example_vector)

# ge tthe mean of a vector
function mean(x::Vector)
    sum = 0
    for i in x
        sum += i
    end
    return sum / length(x)
end

# create vector named bar
# fil it with 10 1's and 10 0's
bar = [ones(10); zeros(10)]
