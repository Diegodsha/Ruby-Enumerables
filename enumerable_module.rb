# rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?

    length.times do |i|
      yield to_a[i]
    end
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    length.times do |i|
      yield to_a[i], i
    end
  end

  def my_select
    return to_enum(:my_select) unless block_given?

    selected = []
    to_a.length.times do |i|
      condition = yield to_a[i]
      selected.push(to_a[i]) if condition
    end
    selected
  end

  def my_all?(param = nil)
    output = true

    length.times do |i|
      if block_given? && !yield(to_a[i])
        output = false
        break
      elsif !block_given? && !to_a[i]
        output = false
        break
      end

      if param.is_a?(Regexp) && !param.match?(to_a[i])
        output = false
        break
      elsif (param.is_a?(Numeric) || param.is_a?(String)) && !to_a[i].is_a?(param)
        output = false
        break
      end

      # if param.is_a?(Regexp) && !param.match?(to_a[i])
      #   output = false
      #   break
      # elsif !param.is_a?(Object) && !to_a[i].is_a?(param)
      #   output = false
      #   break
      # # else
      # #   output = to_a.uniq.length == 1

      # end
      # if param.nil? && !to_a[i]
      #   output = false
      #   break
      # end
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

  def my_map
    return to_enum(:my_map) unless block_given?

    output = []
    to_a.my_each do |item|
      compute = yield item
      output.push(compute)
    end
    output
  end

  def my_inject(accum = nil, sym = nil)
    raise LocalJumpError if accum.nil? && sym.nil? && !block_given?
    #output = 0
    to_a.my_each do |item|
      
      if block_given? && !accum.nil?
        accum = yield accum, item

      elsif block_given? && accum.nil?
        accum = item
        accum = yield accum, item
      elsif !block_given? && (!accum.nil && !sym.nil)
        accum = accum sym to_a[i]
      elsif !block_given && (accum.nil && !sym.nil)
        accum = accum sym item
      end
    end
    accum
  end
end

puts
puts '###### THIS IS MY_EACH METHOD CALL ########'

puts(%w[a b c].my_each { |x| print x, ' -- ' })

puts
puts '###### THIS IS MY_EACH_WITH_INDEX METHOD CALL ########'

hash = {}
%w[cat dog wombat].my_each_with_index do |item, index|
  hash[item] = index
end
p hash

puts
puts '###### THIS IS MY_SELECT METHOD CALL ########'

puts((1..10).my_select { |i| (i % 3).zero? })

puts
puts '###### THIS IS MY_ALL? METHOD CALL ########'

puts(%w[ant bear cat].my_all? { |word| word.include?('a') })
puts([3,4,3,3].my_all?(Float))
puts(%w[ant bear cat].all?(/a/))
puts([nil, true, 99].my_all?)
puts([].my_all?)

puts
puts '###### THIS IS MY_ANY? METHOD CALL ########'

puts(%w[ant bear cat].my_any? { |word| word.length >= 5 })

puts
puts '###### THIS IS MY_NONE? METHOD CALL ########'

puts(%w[ant bear cat].my_none? { |word| word.include?('z') })

puts
puts '###### THIS IS MY_COUNT METHOD CALL ########'

puts [1, 2, 4, 2, 3].my_count(&:even?)

puts
puts '###### THIS IS MY_MAP METHOD CALL ########'

puts((1..5).my_map { |i| i * i })

puts
puts '###### THIS IS MY_INJECT METHOD CALL ########'

puts((5..10).my_inject(1) { |product, n| product * n })
puts((5..10).my_inject { |sum, n| sum + n })
# puts((5..10).my_inject(2, :*))
# puts((5..10).my_inject(:+))

# longest = %w{ cat sheep bear }.inject do |memo, word|
#   memo.length > word.length ? memo : word
# end

# puts longest

# rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
