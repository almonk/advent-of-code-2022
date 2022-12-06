CHARACTER_GROUP_LENGTH = 14

def find_first_non_repeating_group(input_string)
  # Iterate through each character in the string
  input_string.each_char.with_index do |char, index|
    # Get the next four characters
    next_chars_group = input_string[index, CHARACTER_GROUP_LENGTH]

    # Get the character index of the last character in the match
    puts last_char_index = index + next_chars_group.length

    # Check if the next four characters are all unique
    return next_chars_group if next_chars_group.chars.uniq == next_chars_group.chars
  end
end

# Read the input file
input = File.read("input.txt")

# Test the function
puts find_first_non_repeating_group(input)
