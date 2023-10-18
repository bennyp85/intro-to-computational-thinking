using Printf

function remove_timestamps(input_filepath, output_filepath)
    # Open the input file for reading and the output file for writing
    open(input_filepath, "r") do infile
        open(output_filepath, "w") do outfile
            for line in eachline(infile)
                # Use a regular expression to remove timestamps
                cleaned_line = replace(line, r"\d+:\d+" => "")

                # Write the cleaned line to the output file
                @printf(outfile, "%s", cleaned_line)
            end
        end
    end
end


# use raw strings to avoid having to escape backslashes
input_filepath = raw"C:\Users\benny\OneDrive\Documents\input.txt"
output_filepath = raw"C:\Users\benny\OneDrive\Documents\output.txt"

# Call the function to remove timestamps
remove_timestamps(input_filepath, output_filepath)
