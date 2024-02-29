## adjust the generated file by the above cell

# Open the original text file for reading
with open("output.txt", "r") as original_file:
    # Read the lines from the original file
    lines = original_file.readlines()

# Open a new text file for writing
with open("output.coe", "w") as new_file:
    # Write each line with a comma appended at the end
    for line in lines:
        # Strip any existing newline characters and append a comma
        new_line = line.strip() + ","
        # Write the modified line to the new file
        new_file.write(new_line + '\n')

print("New text file with comma appended to each line created: output_pixels_with_comma.txt")