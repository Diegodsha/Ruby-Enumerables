require './enumerable_module'

describe Enumerable do
  let(:array) { [1, 2, 3, 4] }
  let(:string_array) { %w[ab abc abcdta] }
  let(:hash) { { a: 5, b: 8, c: 3, d: 4, e: 9 } }
  let(:number_array) { [1, 21, 3.5] }
  let(:range) { Range.new(1, 50) }
  let(:array_clone) { array.clone }

  describe '#my_each' do
    it 'Works similar to #each method when a block is given.' do
      expect(array.my_each { |els| els + 2 }).to eq(array.each { |idx| (idx + 2) })
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
    it ' return original array' do
      array.my_each_with_index { |el, index| el * index }
      expect(array).to eql(array_clone)
    end
  end
end
