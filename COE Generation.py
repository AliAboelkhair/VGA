## that code works correctly along with the next cell 
############################################################

from PIL import Image

# Load the image
image = Image.open("AMD.png")

# Resize the image to 300x300
image = image.resize((300, 300))

# Convert image to RGB mode (if not already in RGB)
image = image.convert("RGB")

# Get the pixel data
pixel_data = list(image.getdata())

# Function to convert RGB values to 12-bit representation
def convert_to_12_bit(pixel):
    # Extract RGB values
    r, g, b = pixel

    # Convert each channel to 4-bit representation
    r_4bit = (r >> 4) & 0b1111
    g_4bit = (g >> 4) & 0b1111
    b_4bit = (b >> 4) & 0b1111

    # Combine channels into a single 12-bit representation
    return (r_4bit << 8) | (g_4bit << 4) | b_4bit

# Convert each pixel to 12-bit representation
pixels_12_bit = [convert_to_12_bit(pixel) for pixel in pixel_data]

# Open a text file in write mode
with open("output.txt", "w") as file:
    # Write each pixel value in binary format to the file
    for pixel in pixels_12_bit:
        # Convert the pixel value to binary format with 12 bits
        pixel_binary = format(pixel, '012b')
        # Write the binary representation to the file
        file.write(pixel_binary + '\n')

print("Pixel data saved to output.txt")