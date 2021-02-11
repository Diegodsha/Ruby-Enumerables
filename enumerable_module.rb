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

  def my_all?
    output = true
    length.times do |i|
      condition = yield to_a[i]
      unless condition
        output = false
        break
      end
    end
    output
  end

  def my_any?
    output = false
    length.times do |i|
      condition = yield to_a[i]
      if condition
        output = true
        break
      end
    end
    output
  end

  def my_none?
    output = true
    length.times do |i|
      condition = yield to_a[i]
      if condition
        output = false
        break
      end
    end
    output
  end

  def my_count(param = nil)
    count = 0
    length.times do |i|
      if block_given?
        count += 1 if yield to_a[i]
      elsif param.nil?
        count = length
      elsif to_a[i] == param
        count += 1
      end
    end
    count
  end
end

[1, 2, 3, 4, 5].my_each { |num| puts num }

puts

20.times { print '-' }
puts
puts 'THIS IS MY_EACH_WITH_INDEX EXECUTION'

my_array = { name: 'Diego', country: 'Mexico' }
my_array.my_each_with_index do |data, idx|
  puts "The #{data[0]} is #{data[1]}" if idx == 1
end

20.times { print '-' }
puts
puts 'THIS IS MY_SELECT METHOD CALL'

[2, 3, 4, 6, 7, 16].my_select { |num| puts num if num.even? }

20.times { print '-' }
puts
puts 'THIS IS MY_ALL? METHOD CALL'

puts(%w[ant bear cat].my_all? { |word| word.include?('b') })

20.times { print '-' }
puts
puts 'THIS IS MY_ANY? METHOD CALL'

puts(%w[ant bear cat].my_any? { |word| word.length >= 5 })

puts
puts '###### THIS IS MY_NONE? METHOD CALL ########'

puts(%w[ant bear cat].my_none? { |word| word.include?('z') })

puts
puts '###### THIS IS MY_COUNT? METHOD CALL ########'

puts [1, 2, 4, 2, 3].my_count(&:even?)
