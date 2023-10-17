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


# example[
# 	noisify(color_red, strength)
# 	for 
# 		strength in 0 : 0.05 : 1,
# 		row in 1:10
# ]'
# Write the third method noisify(image::AbstractMatrix, s) to noisify each pixel of an image. This function should be a single line!
function noisify(image::AbstractMatrix, s)
    result = [noisify(pixel, s) for pixel in image]
    return result
end

# Write a function box_blur(v, l) that blurs a vector v with a window of length l by averaging the elements within a window from 
#     to 
#    . This is called a box blur. Use your function extend to handle the boundaries correctly.

#    Return a vector of the same size as v.



function extend(v::AbstractVector, i)
    if i in v
        return i
    else
        nearest_val, _ = findmin(abs.(v .- i))
        return nearest_val[_]
    end
end

function mean(v)
    sum = my_sum(v)
    result = sum / length(v)
    return result
end

function my_sum(v)
    result = 0
    for elem in v
        result += elem
    end
    return result
end

function extend(v::AbstractVector, i)
    if i in v
        return i
    else
        nearest_val, _ = findmin(abs.(v .- i))
        return nearest_val[_]
    end
end


function box_blur(v::AbstractArray, l)
    result_vector = []
    # find the mean of the windows from -l to l
    # use extend for the boundaries
    for i in 1:length(v)
        window = []
        for j in -l:l
            push!(window, extend(v, i + j))
        end
        push!(result_vector, mean(window))
    end
end




test_convolution = let
    v = [1, 10, 100, 1000, 10000]
    k = [1, 1, 0]
    convolve(v, k)
end


x = [1, 10, 100]
result = convolve(x, [0, 1, 1])
shouldbe = [11, 110, 200]
shouldbe2 = [2, 11, 110]

function convolve(v::AbstractVector, k)
    # get length of v and K
    v_length = length(v)
    k_length = length(k)
    # we can use the extend function to cater for the boundaries
    result_vector = []
    for i in 1:v_length
        window = []
        for j in 1:k_length
            push!(window, extend(v, i + j))
        end
        push!(result_vector, dot(window, k))
    end
    return result_vector
end