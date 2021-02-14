require 'rspec'
require_relative '../app.rb'

ARRAY_SIZE = 100
LOWEST_VALUE = 0
HIGHEST_VALUE = 9

describe 'enumerables' do
  let(:array) { Array.new(ARRAY_SIZE) { rand(LOWEST_VALUE...HIGHEST_VALUE) } }
  let(:block) { proc { |num| num < (LOWEST_VALUE + HIGHEST_VALUE) / 2 } }
  let(:words) { %w[dog door rod blade] }
  let(:range) { Range.new(5, 50) }
  let(:hash) { { a: 1, b: 2, c: 3, d: 4, e: 5 } }
  let(:numbers) { [1, 2i, 3.14] }
  let!(:array_clone) { array.clone }

  describe '#my_each' do
    shared_examples '#each' do
      it 'calls the given block once for each element in self' do
        my_each_output = ''
        block = proc { |num| my_each_output += num.to_s }
        enum.each(&block)
        each_output = my_each_output.dup
        my_each_output = ''
        enum.my_each(&block)
        expect(my_each_output).to eq(each_output)
      end
    end

    it 'returns an Enumerator if no block is given' do
      expect(array.my_each).to be_an(Enumerator)
    end

    it 'does not mutate the original array' do
      array.my_each { |num| num + 1 }
      expect(array).to eq(array_clone)
    end

    context 'when a block is given' do
      context 'when self is an array' do
        it_behaves_like '#each' do
          let(:enum) { array }
        end

        it 'returns the array itself after calling the given block once for each element in self' do
          expect(array.my_each(&block)).to eq(array.each(&block))
        end
      end

      context 'when self is a range' do
        it_behaves_like '#each' do
          let(:enum) { range }
        end

        it 'returns the range itself after calling the given block once for each element in self' do
          expect(range.my_each(&block)).to eq(range.each(&block))
        end
      end

      context 'when self is a hash' do
        it_behaves_like '#each' do
          let(:enum) { hash }
        end
      end
    end
  end

  describe '#my_each_with_index' do
    shared_examples '#each_with_index' do
      it 'calls the given block once for each element in self' do
        my_each_with_index_output = ''
        block = proc { |num, idx| my_each_with_index_output += "Num: #{num}, idx: #{idx}\n" }
        enum.each_with_index(&block)
        each_with_index_output = my_each_with_index_output.dup
        my_each_with_index_output = ''
        enum.my_each_with_index(&block)
        expect(my_each_with_index_output).to eq(each_with_index_output)
      end
    end

    it 'returns an enumerator if no block is given' do
      expect(array.my_each_with_index).to be_an(Enumerator)
    end

    it 'does not mutate the original array' do
      array.my_each_with_index { |num| num + 1 }
      expect(array).to eq(array_clone)
    end

    context 'when a block is given' do
      context 'when self is an array' do
        it_behaves_like '#each_with_index' do
          let(:enum) { array }
        end

        it 'returns the array itself after calling the given block once for each element in self' do
          expect(array.my_each_with_index(&block)).to eq(array.each_with_index(&block))
        end
      end

      context 'when self is a range' do
        it_behaves_like '#each_with_index' do
          let(:enum) { range }
        end

        it 'returns the range itself after calling the given block once for each element in self' do
          expect(range.my_each_with_index(&block)).to eq(range.each_with_index(&block))
        end
      end

      context 'when self is a hash' do
        it_behaves_like '#each_with_index' do
          let(:enum) { hash }
        end
      end
    end
  end

  describe '#my_select' do
    it 'returns an array containing all elements of enum for which the given block returns a true value' do
      expect(array.my_select(&block)).to eq(array.select(&block))
    end

    it 'returns an array containing all elements of enum for which the given block returns a true value::range' do
      expect(range.my_select(&block)).to eq(range.select(&block))
    end

    it 'returns an enumerator if no block is given' do
      expect(array.my_select).to be_an(Enumerator)
    end

    it 'does not mutate the original array' do
      array.my_select { |num| num + 1 }
      expect(array).to eq(array_clone)
    end
  end

  describe '#my_all?' do
    let(:true_block) { proc { |num| num <= HIGHEST_VALUE } }
    let(:false_block) { proc { |num| num > HIGHEST_VALUE } }
    it 'returns true if the block never returns false or nil' do
      expect(array.my_all?(&true_block)).to eq(array.all?(&true_block))
    end

    it 'returns false if the block returns false or nil' do
      expect(array.my_all?(&false_block)).to eq(array.all?(&false_block))
    end

    it 'returns false if the block returns false or nil::range' do
      expect(range.my_all?(&false_block)).to eq(range.all?(&false_block))
    end

    it 'does not mutate the original array' do
      array.my_all? { |num| num + 1 }
      expect(array).to eq(array_clone)
    end

    context 'when no block or argument is given' do
      let(:true_array) { [1, true, 'hi', []] }
      let(:false_array) { [1, false, 'hi', []] }
      it 'returns true when none of the collection members are false or nil' do
        expect(true_array.my_all?).to be true_array.all?
      end

      it 'returns false when one of the collection members are false or nil' do
        expect(false_array.my_all?).to be false_array.all?
      end
    end

    context 'when a class is passed as an argument' do
      it 'returns true if all of the collection is a member of such class::Integer' do
        expect(array.my_all?(Integer)).to be array.all?(Integer)
      end

      it 'returns true if all of the collection is a member of such class::Numeric' do
        expect(numbers.my_all?(Numeric)).to be numbers.all?(Numeric)
      end

      it 'returns false if any of the collection is not a member of such class' do
        array[0] = 'word'
        expect(array.my_all?(Integer)).to be array.all?(Integer)
      end
    end

    context 'when a Regex is passed as an argument' do
      it 'returns true if all of the collection matches the Regex' do
        expect(words.my_all?(/d/)).to be words.all?(/d/)
      end

      it 'returns false if any of the collection does not match the Regex' do
        expect(words.my_all?(/o/)).to be words.all?(/o/)
      end
    end

    context 'when a pattern other than Regex or a Class is given' do
      it 'returns true if all of the collection matches the pattern' do
        array = []
        5.times { array << 3 }
        expect(array.my_all?(3)).to be array.all?(3)
      end

      it 'returns false if any of the collection does not match the pattern' do
        expect(array.my_all?(3)).to be array.all?(3)
      end
    end
  end

  describe '#my_any?' do
    let(:true_block) { proc { |num| num <= HIGHEST_VALUE } }
    let(:false_block) { proc { |num| num > HIGHEST_VALUE } }
    it 'returns true if the block ever returns a value other than false or nil' do
      expect(array.my_any?(&true_block)).to eq(array.any?(&true_block))
    end

    it 'returns false if the block ever returns a value false or nil' do
      expect(array.my_any?(&false_block)).to eq(array.any?(&false_block))
    end

    it 'returns false if the block ever returns a value false or nil::range' do
      expect(range.my_any?(&false_block)).to eq(range.any?(&false_block))
    end

    it 'does not mutate the original array' do
      array.my_any? { |num| num + 1 }
      expect(array).to eq(array_clone)
    end

    context 'when no block or argument is given' do
      let(:true_array) { [nil, false, true, []] }
      let(:false_array) { [nil, false, nil, false] }
      it 'returns true if at least one of the collection is not false or nil' do
        expect(true_array.my_any?).to be true_array.any?
      end

      it 'returns false if at least one of the collection is not true' do
        expect(false_array.my_any?).to be false_array.any?
      end
    end

    context 'when a class is passed as an argument' do
      it 'returns true if at least one of the collection is a member of such class::Numeric' do
        expect(array.my_any?(Numeric)).to be array.any?(Numeric)
      end

      it 'returns true if at least one of the collection is a member of such class::Integer' do
        expect(words.my_any?(Integer)).to be words.any?(Integer)
      end
    end

    context 'when a Regex is passed as an argument' do
      it 'returns true if any of the collection matches the Regex' do
        expect(words.my_any?(/d/)).to be words.any?(/d/)
      end

      it 'returns false if none of the collection matches the Regex' do
        expect(words.my_any?(/z/)).to be words.any?(/z/)
      end
    end

    context 'when a pattern other than Regex or a Class is given' do
      it 'returns false if none of the collection matches the pattern' do
        expect(words.my_any?('cat')).to be words.any?('cat')
      end

      it 'returns true if any of the collection matches the pattern' do
        words[0] = 'cat'
        expect(words.my_any?('cat')).to be words.any?('cat')
      end
    end
  end

  describe '#my_none?' do
    let(:true_block) { proc { |num| num > HIGHEST_VALUE } }
    let(:false_block) { proc { |num| num <= HIGHEST_VALUE } }
    let(:true_array) { [nil, false, true, []] }
    let(:false_array) { [nil, false, nil, false] }
    it 'returns true if the block never returns true for all elements' do
      expect(array.my_none?(&true_block)).to eq(array.none?(&true_block))
    end

    it 'returns false if the block ever returns true for all elements' do
      expect(array.my_none?(&false_block)).to eq(array.none?(&false_block))
    end

    it 'returns false if the block ever returns true for all elements::range' do
      expect(range.my_none?(&false_block)).to eq(range.none?(&false_block))
    end

    it 'does not mutate the original array' do
      array.my_none? { |num| num + 1 }
      expect(array).to eq(array_clone)
    end

    context 'when no block or argument is given' do
      it 'returns true only if none of the collection members is true' do
        expect(false_array.my_none?).to be true
      end

      it 'returns false only if one of the collection members is true' do
        expect(true_array.my_none?).to be false
      end
    end

    context 'when a class is passed as an argument' do
      it 'returns true if none of the collection is a member of such class' do
        expect(array.my_none?(String)).to be array.my_none?(String)
      end

      it 'returns true if none of the collection is a member of such class::Numeric' do
        expect(array.my_none?(Numeric)).to be array.my_none?(Numeric)
      end

      it 'returns false if any of the collection is a member of such class' do
        array[0] = 'hi'
        expect(array.my_none?(String)).to be array.my_none?(String)
      end
    end

    context 'when a Regex is passed as an argument' do
      it 'returns true if none of the collection matches the Regex' do
        expect(words.my_none?(/z/)).to be words.none?(/z/)
      end

      it 'returns false if any of the collection matches the Regex' do
        expect(words.my_none?(/d/)).to be words.none?(/d/)
      end
    end

    context 'when a pattern other than Regex or a Class is given' do
      it 'returns true only if none of the collection matches the pattern' do
        expect(words.my_none?(5)).to be words.none?(5)
      end
      it 'returns false only if one of the collection matches the pattern' do
        words[0] = 5
        expect(words.my_none?(5)).to be words.none?(5)
      end
    end
  end

  describe '#my_count' do
    it 'returns the number of items in enum through enumeration' do
      expect(array.my_count).to eq array.count
    end

    it 'returns the number of items in enum through enumeration::range' do
      expect(range.my_count).to eq range.count
    end

    it 'counts the number of items in enum that are equal to item if an argument is given' do
      expect(array.my_count(LOWEST_VALUE)).to eq array.count(LOWEST_VALUE)
    end

    it 'counts the number of elements yielding a true value if a block is given' do
      expect(array.my_count(&block)).to eq array.count(&block)
    end

    it 'does not mutate the original array' do
      array.my_count { |num| num + 1 }
      expect(array).to eq(array_clone)
    end
  end

  describe '#my_map' do
    let(:my_proc) { proc { |num| num > 10 } }

    # step 8 from the Odin project Asignment
    it 'returns a new array with the results of running a given block once for every element in enum.' do
      expect(array.my_map { |num| num < 10 }).to eq(array.map { |num| num < 10 })
    end

    it 'returns a new array with the results of running a given block once for every element in enum.' do
      expect(array.my_map(&block)).to eq array.map(&block)
    end

    it 'returns a new array with the results of running a given block once for every element in enum::range' do
      expect(range.my_map(&block)).to eq range.map(&block)
    end

    it 'returns an Enumerator if no block is given' do
      expect(array.my_map).to be_an(Enumerator)
    end

    # step 11 from the Odin project Asignment
    it 'accepts a proc as an argument and returns a new array with the results '\
       'of running the proc once for every element in enum.' do
      expect(array.my_map(&my_proc)).to eq array.map(&my_proc)
    end

    # step 12 from the Odin project Asignment
    it 'executes only the proc when both a block and a proc are given and returns '\
       'a new array with the results of running the proc once for every element in enum.' do
      expect(array.my_map(my_proc) { |num| num < 10 }).to eq array.map(&my_proc)
    end

    it 'does not mutate the original array' do
      array.my_map { |num| num + 1 }
      expect(array).to eq(array_clone)
    end
  end

  describe '#my_inject' do
    let(:operation) { proc { |sum, n| sum + n } }
    let(:search) { proc { |memo, word| memo.length > word.length ? memo : word } }

    it 'raises a "LocalJumpError" when no block or argument is given' do
      expect { array.my_inject }.to raise_error(LocalJumpError)
    end

    it 'searches for the longest word in an array of strings' do
      expect(words.my_inject(&search)).to eq words.inject(&search)
    end

    it 'does not mutate the original array' do
      array.my_inject { |num| num + 1 }
      expect(array).to eq(array_clone)
    end

    context 'when a block is given without an initial value' do
      it 'combines all elements of enum by applying a binary operation, specified by a block' do
        expect(array.my_inject(&operation)).to eq array.inject(&operation)
      end

      it 'combines all elements of enum by applying a binary operation, specified by a block::range' do
        actual = range.my_inject { |prod, n| prod * n }
        expected = range.inject { |prod, n| prod * n }
        expect(actual).to eq expected
      end
    end

    context 'when a block is given with an initial value' do
      it 'combines all elements of enum by applying a binary operation, specified by a block' do
        actual = range.my_inject(4) { |prod, n| prod * n }
        expected = range.inject(4) { |prod, n| prod * n }
        expect(actual).to eq expected
      end
    end

    context 'when a symbol is specified without an initial value' do
      it 'combines each element of the collection by applying the symbol as a named method' do
        expect(array.my_inject(:+)).to eq array.inject(:+)
      end

      it 'combines each element of the collection by applying the symbol as a named method:range' do
        expect(range.my_inject(:*)).to eq range.inject(:*)
      end
    end

    context 'when a symbol is specified with an initial value' do
      it 'combines each element of the collection by applying the symbol as a named method' do
        expect(array.my_inject(20, :*)).to eq array.inject(20, :*)
      end

      it 'combines each element of the collection by applying the symbol as a named method::range' do
        expect(range.my_inject(2, :*)).to eq range.inject(2, :*)
      end
    end
  end

  describe '#multiply_els' do
    it 'accepts an array as an argument and multiplies all the elements of the array together using #my_inject' do
      actual = multiply_els [2, 4, 5]
      expect(actual).to eq 40
    end
  end
end
