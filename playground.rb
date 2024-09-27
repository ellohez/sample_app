puts "Welcome!"

#
# Word frequency counting
#
def words_from_string(string)
  string.downcase.scan(/[\w']+/)
end

# Using 0 as the default value for hash entries removes need to check the entry exists in case we are
# encountering a word for the first time before setting to 1 and only incrementing if it already exists
def count_frequency(word_list)
  counts = Hash.new(0)
  word_list.each do |word|
    counts[word] += 1
  end
  counts
end

words = words_from_string("If this is that and that is this, then what does it all mean?")
frequencies = count_frequency(words)
p frequencies
# Accessing an entry in the hash by its key
p frequencies['if']

puts "Sorted by values (ascending)"
p frequencies.sort_by {|key, value| value }

puts "Sorted by values (descending)"
p frequencies.sort_by {|k, v| -v }

puts "Sort by values (descending) and then by keys(ascending)"
sorted = frequencies.sort_by {|word, count| [-count, word] }
p sorted
top_five = sorted.first(5)

p "The top 5 most frequent words are:"
top_five.each do |word, count|
  puts "#{word}: #{count}"
end

# Hashes with symbols as keys