module Enumerable
  def my_each
    length.times do |i|
      yield to_a[i]
    end
  end
end

[1, 2, 3, 4, 5].my_each { |num| puts num }
