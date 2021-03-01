require './enumerable_module'

describe Enumerable do
  let(:array) { [1, 2, 3, 4] }
  let(:string_array) { %w[ab abc abcdta] }
  let(:hash) { { a: 5, b: 8, c: 3, d: 4, e: 9 } }
  let(:number_array) { [1, 21, 3.5] }
  let(:range) { Range.new(1, 50) }
  let(:number_block) { proc { |num| num * 2 } }
  let(:array_clone) { array.clone }
  let(:block) { proc { |item| item.length >= 3 } }

  describe '#my_each' do
    it 'Works similar to #each method when a block is given.' do
      expect(array.my_each { |els| (els + 2) }).to eq(array.each { |idx| idx.send('+', 2) })
    end
    it 'returns enumerator if block is not given' do
      expect(array.my_each).to be_an(Enumerator)
    end
    it ' return original array' do
      array.my_each { |el| el * 2 }
      expect(array).to eql(array_clone)
    end
  end

  describe '#my_each_with_index' do
    it 'Works similar to #each method when a block is given.' do
      expect(array.my_each_with_index { |els, index| els + index }).to eql(array.each_with_index do |i, index|
                                                                             i + index
                                                                           end)
    end
    it 'returns enumerator if block is not given' do
      expect(array.my_each_with_index).to be_an(Enumerator)
    end
    it 'return original array' do
      array.my_each_with_index { |el, index| el * index }
      expect(array).to eql(array_clone)
    end
  end

  describe '#my_select' do
    it 'returns array of elements that is true to given block' do
      expect(string_array.my_select(&block)).to eql(string_array.select(&block))
    end

    it 'returns an array of of all element that is true to the given block if self is a range' do
      expect(range.my_select(&number_block)).to eql(range.select(&number_block))
    end

    it 'returns an enumerator if no block is given' do
      expect(array.my_select).to be_an(Enumerator)
    end
    it 'does not alter the original array' do
      array.my_select { |num| num + 5 }
      expect(array).to eq(array_clone)
    end
  end
end
