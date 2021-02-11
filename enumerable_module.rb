module Enumerable
  def my_each
    length.times do |i|
      yield to_a[i]
    end
  end

  def my_each_with_index
    length.times do |i|
      yield to_a[i], i
    end
  end

  def my_select
    selected = []
    length.times do |i|
      condition = yield to_a[i]
      selected.push(to_a[i]) if condition
    end
    selected
  end
end

[1, 2, 3, 4, 5].my_each { |num| puts num }

puts

20.times { print '-' }
puts
puts 'THIS IS MY_EACH_WITH_INDEX_EXECUTION'

my_array = { name: 'Diego', country: 'Mexico' }
my_array.my_each_with_index do |data, idx|
  puts "The #{data[0]} is #{data[1]}" if idx == 1
end

20.times { print '-' }
puts
puts 'THIS IS MY_SELECT'

[2, 3, 4, 6, 7, 16].my_select { |num| puts num if num.even? }
