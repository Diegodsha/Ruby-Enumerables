# rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
# rubocop:disable Metrics/ModuleLength

module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?

    to_a.length.times do |i|
      yield to_a[i]
    end
    self
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    to_a.length.times do |i|
      yield to_a[i], i
    end
    self
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

    if block_given?
      to_a.my_each { |item| return false unless yield(item) }
    elsif !block_given? && param.nil?
      to_a.my_each { |item| return false unless item }
    elsif param.is_a?(Regexp)
      to_a.my_each { |item| return false unless param.match?(item) }
    elsif param.is_a?(Class)
      to_a.my_each { |item| return false unless item.is_a?(param) }
    else
      output = uniq.length == 1
    end
    output
  end

  def my_any?(param = nil)
    output = false
    if block_given?
      to_a.my_each { |item| return true if yield(item) }
    elsif !block_given? && param.nil?
      return output = false if to_a.empty?

      to_a.my_each { |item| return true if item }
    elsif param.is_a?(Regexp)
      to_a.my_each { |item| return true if param.match?(item) }
    elsif param.is_a?(Class)
      to_a.my_each { |item| return true if item.is_a?(param) }
    else
      to_a.my_each { |item| return true if item == param }
    end
    output
  end

  def my_none?(param = nil)
    output = true
    if block_given?
      to_a.my_each { |item| return false if yield(item) }
    elsif !block_given? && param.nil?
      to_a.my_each { |item| return false if item }
    elsif param.is_a?(Regexp)
      to_a.my_each { |item| return false if param.match?(item) }
    elsif param.is_a?(Class)
      to_a.my_each { |item| return false if item.is_a?(param) }
    else
      to_a.my_each { |item| return false if item == param }
    end
    output
  end

  def my_count(param = nil)
    count = 0
    to_a.length.times do |i|
      if block_given?
        count += 1 if yield to_a[i]
      elsif param.nil?
        count = to_a.length
      elsif to_a[i] == param
        count += 1
      end
    end
    count
  end

  def my_map(param = nil)
    return to_enum(:my_map) unless block_given? || param

    output = []
    if param
      to_a.my_each { |item| output.push(param.call(item)) }
    else
      to_a.my_each { |item| output.push(yield(item)) }
    end
    output
  end

  def my_inject(param = nil, sym = nil)
    raise LocalJumpError if param.nil? && sym.nil? && !block_given?

    if block_given? && !param.nil?
      to_a.my_each { |item| param = yield(param, item) }
    elsif block_given? && param.nil?
      param = to_a[0]

      (to_a.length - 1).times { |index| param = yield(param, to_a[index + 1]) }

    elsif !param.nil? && !sym.nil?
      to_a.my_each { |item| param = param.send(sym, item) }
    elsif param.is_a?(Symbol) && sym.nil?
      accum = to_a[0]
      (to_a.length - 1).times { |index| accum = accum.send(param, to_a[index + 1]) }
      param = accum
    end
    param
  end
end

def multiply_els(arr)
  my_block = proc { |product, n| product * n }
  arr.my_inject(&my_block)
end

# rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
# rubocop:enable Metrics/ModuleLength
