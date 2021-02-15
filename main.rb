require_relative 'enumerable_module.rb'

puts
puts '###### THIS IS MY_EACH METHOD CALL ########'

%w[a b c].my_each { |x| print x, ' -- ' }

puts
puts '###### THIS IS MY_EACH_WITH_INDEX METHOD CALL ########'

hash = {}
%w[cat dog wombat].my_each_with_index do |item, index|
  hash[item] = index
end
p hash

puts
puts '###### THIS IS MY_SELECT METHOD CALL ########'

p((1..10).my_select { |i| (i % 3).zero? }) #=> [3, 6, 9]

p([1, 2, 3, 4, 5].my_select(&:even?)) #=> [2, 4]

p(%i[foo bar].my_select { |x| x == :foo }) #=> [:foo]

puts
puts '###### THIS IS MY_ALL? METHOD CALL ########'

puts(%w[ant bear cat].my_all? { |word| word.include?('a') }) # true
puts([3, 4.7, 3, 3].my_all?(Numeric)) # true
puts((1..10).my_all?(Float)) # false
puts(%w[ant bear cat].all?(/z/)) # false
puts([nil, true, 99].my_all?) # false
puts([].my_all?) # true
puts([3, 3, 3, 3].my_all?(3)) # true

puts
puts '###### THIS IS MY_ANY? METHOD CALL ########'

puts(%w[ant bear cat].my_any? { |word| word.length >= 3 }) #=> true
puts(%w[ant bear cat].my_any? { |word| word.length >= 5 }) #=> false
puts(%w[ant bear cat].my_any?(/d/)) #=> false
puts([nil, true, 99].my_any?(Integer)) #=> true
puts([nil, true, 99].my_any?) #=> true
puts([3, 3, 3].my_any?(3)) #=> true
puts([].my_any?) # => true

puts
puts '###### THIS IS MY_NONE? METHOD CALL ########'

p(%w[ant bear cat].my_none? { |word| word.length == 5 }) #=> true
p(%w[ant bear cat].my_none? { |word| word.length >= 4 }) #=> false
p(%w[ant bear cat].none?(/d/)) #=> true
p([1, 3.14, 42].my_none?(Float)) #=> false
p([1, 3.14, 42].my_none?(5)) #=> true
p([].none?) #=> true
p([nil].none?) #=> true
p([nil, false].none?) #=> true
p([nil, false, true].none?) #=> false

puts
puts '###### THIS IS MY_COUNT METHOD CALL ########'

ary = [1, 2, 4, 2]
puts ary.my_count #=> 4
puts ary.my_count(2) #=> 2
puts(ary.count(&:even?)) #=> 3

puts
puts '###### THIS IS MY_MAP METHOD CALL ########'

p((1..4).my_map { |i| i * i }) #=> [1, 4, 9, 16]
p((1..4).my_map { 'cat' }) #=> ["cat", "cat", "cat", "cat"]

my_proc = proc { |i| i * i }
p((1..6).my_map(my_proc))

puts
puts '###### THIS IS MY_INJECT METHOD CALL ########'

puts((5..10).my_inject(2) { |product, n| product * n }) #=> 151200
puts((5..10).my_inject { |sum, n| sum + n }) #=> 45
puts((5..10).my_inject(20, :*)) #=> 151200
puts((5..10).my_inject(:+)) #=> 45

arr = %w[bear sheep goat]
longest = arr.inject do |memo, word|
  memo.length > word.length ? memo : word
end

puts longest

def multiply_els(arr)
  arr.my_inject(:*)
end

puts multiply_els([2, 4, 5])
