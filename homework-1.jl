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

# this is returning the correct result
# this has a normalized kernel length of 1
function box_blur_kernel(l)
    return fill(1 / (2 * l + 1), 2 * l + 1)
end


gauss(x::Real; σ=1) = 1 / sqrt(2π * σ^2) * exp(-x^2 / (2 * σ^2))

# sampling at each pixel at length 2n + 1
function gaussian_kernel_1D(n; σ=1)
    result = []
    for i in -n:n
        push!(result, gauss(i, σ=σ))
    end
    # normalize so that the sum is 1
    return result / sum(result)

end

# return wrong size of vector
function convolve(v::AbstractVector, k::AbstractVector)
    v_length = length(v)
    k_length = length(k)
    offset = floor(Int, k_length ÷ 2)

    result_vector = OffsetArray{Float64}(undef, 1-offset:1-offset+v_length)

    for i in 1-offset:1-offset+v_length
        window = OffsetArray{Float64}(undef, -offset:offset)

        for j in -offset:offset
            window[j] = extend(v, i + j)
        end

        result_vector[i] = dot(window, k)
    end

    return result_vector
end

function extend(M::AbstractMatrix, i, j)
    nrows, ncols = size(M)

    # Handle row index
    if i <= 0
        i = 1
    elseif i > nrows
        i = nrows
    end

    # Handle column index
    if j <= 0
        j = 1
    elseif j > ncols
        j = ncols
    end

    return M[i, j]
end

# 2D convolution

#👉 Implement a new method convolve(M, K) that applies a convolution to a 2D array M, using a 2D kernel K. Use your new method extend from the last exercise.

function convolve(M::AbstractMatrix, K::AbstractMatrix)
    nrows, ncols = size(M)
    krows, kcols = size(K)
    offset_row = floor(Int, krows ÷ 2)
    offset_col = floor(Int, kcols ÷ 2)

    # do not use Float64
    result_matrix = OffsetArray{Float64}(undef, 1-offset_row:1-offset_row+nrows, 1-offset_col:1-offset_col+ncols)
    for i in 1-offset_row:1-offset_row+nrows
        for j in 1-offset_col:1-offset_col+ncols
            window = OffsetArray{Float64}(undef, -offset_row:offset_row, -offset_col:offset_col)
            for k in -offset_row:offset_row
                for l in -offset_col:offset_col
                    window[k, l] = extend(M, i + k, j + l)
                end
            end
            result_matrix[i, j] = dot(window, K)
        end
    end
    return result_matrix
end

# G{total} = sqrt{G_x^2 + G_y^2}

```math
G_x = \begin{bmatrix}
1 & 0 & -1 \\
2 & 0 & -2 \\
1 & 0 & -1 \\
\end{bmatrix};
\qquad
G_y = \begin{bmatrix}
1 & 2 & 1 \\
0 & 0 & 0 \\
-1 & -2 & -1 \\
\end{bmatrix} 
```

function with_sobel_edge_detect(image)
    G_x = [1 0 -1; 2 0 -2; 1 0 -1]
    G_y = [1 2 1; 0 0 0; -1 -2 -1]
    G_x = G_x / sum(G_x)
    G_y = G_y / sum(G_y)
    G_x = convolve(image, G_x)
    G_y = convolve(image, G_y)
    G_total = sqrt.(G_x .^ 2 .+ G_y .^ 2)
    return G_total
end

# find the values in sample_freqs with frequency 0
#  map to alphabet
unused_letters = map(i -> alphabet[i], findall(x -> x == 0, sample_freqs))


# To find the frequency of the "th" transition, you need to locate this transition in the 2D array generated by transition_counts. 
# The "th" transition corresponds to the pair of letters "t" and "h". In Julia, you can access elements in a 2D array using indices. 
# The first index corresponds to the row and the second index corresponds to the column. 
# In this case, you need to find the row and column that correspond to the letters "t" and "h" in the alphabet array.
transition_frequencies = normalize_array ∘ transition_counts;
t = findfirst(x -> x == 't', alphabet)
h = findfirst(x -> x == 'h', alphabet)

th_frequency = transition_frequencies[t, h]

show_pair_frequencies(transition_frequencies(first_sample))
# double letter will be at indices 00, 11, 22, 33, 44, 55, 66, 77, 88, 99 all the way to the end of the alphabet
double_letter_frequencies = [transition_frequencies[i, i] for i in 1:length(alphabet)]

begin
    # Find the index of the maximum value in the sample_freq_matrix array
    index = argmax(sample_freq_matrix[index_of_letter('w'), :])

    # Use this index to access the corresponding letter in the alphabet array
    most_likely_to_follow_w = alphabet[index]

end

if !@isdefined(most_likely_to_follow_w)
    not_defined(:most_likely_to_follow_w)
else
    let
        result = most_likely_to_follow_w
        if result isa Missing
            still_missing()
        elseif !(result isa Char)
            keep_working(md"Make sure that you return a `Char`. You might want to use the `alphabet` to index a character.")
        elseif result == alphabet[map(alphabet) do c
            sample_freq_matrix[index_of_letter('w'), index_of_letter(c)]
        end|>argmax] #= =#
            correct()
        else
            keep_working()
        end
    end
end

# 👉 Which letter is most likely to precede a W?

# most_like_to_precede_w = alphabet[argmax(sample_freq_matrix[:, index_of_letter('w')])]

# 👉 What is the sum of each row? What is the sum of each column? What is the sum of the matrix? How can we interpret these values?"
row_sums = sum(sample_freq_matrix, dims=2)
column_sums = sum(sample_freq_matrix, dims=1)
matrix_sum = sum(sample_freq_matrix)