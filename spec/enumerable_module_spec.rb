require './enumerable_module'

ARRAY_SIZE = 50
LOWEST_VALUE = 0
HIGHEST_VALUE = 9

describe Enumerable do
    let(:array) { Array.new(ARRAY_SIZE) {rand(LOWEST_VALUE...HIGHEST_VALUE)}} 
    let(:array_clone) { array.clone } 
    let(:block) { proc {|value| value + 1} } 
    let(:block_index) { proc {|value, index| value + index} } 
    let(:array_str) { %w[ant bear cat] }
    let(:array_numeric) { [1, 2i, 3.14] }
    let(:array_falsy){ [nil, true, 99] }
    let(:array_truthy){ [true, true, 99] }
    let(:array_empty){ [] }

describe "#my_each" do
    it "Returns an Enumerator if no block is given" do
        expect(array.my_each).to be_an Enumerator
    end

    it "It does not mutate the original array" do
        expect(array.my_each(&block)).to eq(array_clone)
    end
    
    it "It excecutes the given code block once for each element" do
        my_output = 0
        block = proc {|value| my_output += value}
        array.my_each(&block)
        first_output = my_output.dup
        my_output = 0
        array.each(&block)
        expect(first_output).to eq(my_output)
    end
end

describe "#my_each_with_index" do
    it "Returns an Enumerator if no block is given" do
        expect(array.my_each_with_index).to be_an Enumerator
    end

    it "It does not mutate the original array" do
        expect(array.my_each_with_index(&block)).to eq(array_clone)
    end
    
    it "It excecutes the given code block once for each element and takes the index of each element" do
        index_sum = 0
        block = proc {|value, index| index_sum += index}
        array.my_each_with_index(&block)
        first_index_sum = index_sum.dup
        index_sum = 0
        array.each_with_index(&block)
        expect(first_index_sum).to eq(index_sum)
    end
end

describe "#my_select" do
    it "Returns an Enumerator if no block is given" do
        expect(array.my_select).to be_an Enumerator
    end

    it "It does not mutate the original array" do
        expect(array.my_each_with_index(&block)).to eq(array_clone)
    end
    
    it "It returns an array containing all elements of enum for wich the given block returns true value" do
        block = proc { |num| num.even?}
        first_array= array.my_select(&block)
        second_array = array.select(&block)
        expect(first_array).to  eq(second_array)
    end
    
end

describe "#my_all?" do

    it "Returns true if block never return false" do
        block = proc { |str| str.length >= 3 }
        expect(array_str.my_all?(&block)).to be true
    end
    it "Returns false if block never return true" do
        block = proc { |str| str.length >= 4 }
        expect(array_str.my_all?(&block)).to be false
    end
    it "Returns false if not all elements match the regular expression" do
        expect(array_str.my_all?(/t/)).to be false
    end
    it "Returns true if all elements match the regular expression" do
        expect(array_str.my_all?(/a/)).to be true
    end
    it "Returns true if all elements are the same class" do
        expect(array_numeric.my_all?(Numeric)).to be true
    end
    it "Returns false if not all elements are the same class" do
        expect(array_numeric.my_all?(String)).to be false
    end
    it "Return true if all elements are truthy" do
        expect(array_truthy.my_all?).to be true
    end
    it "Return true if array is empty" do
        expect(array_empty.my_all?).to be true
    end

    
end

describe "#my_any?" do

    it "Returns true if any of the elements return true" do
        block = proc { |str| str.length >= 3 }
        expect(array_str.my_any?(&block)).to be true
    end

    it "Returns false if any of the elements return false" do
        block = proc { |str| str.length >= 5 }
        expect(array_str.my_any?(&block)).to be false
    end

    it "Returns true if any element match the regular expression" do
        expect(array_str.my_any?(/t/)).to be true
    end

    it "Returns false if any element don't match the regular expression" do
        expect(array_str.my_any?(/z/)).to be false
    end

    it "Returns true if any element are the same class" do
        expect(array_falsy.my_any?(Numeric)).to be true
    end

    it "Returns false if any element is not the same class" do
        expect(array_numeric.my_any?(String)).to be false
    end

    it "Returns true if any element is truthy" do
        expect(array_truthy.my_any?).to be true
    end

    it "Return false if array is empty" do
        expect(array_empty.my_any?).to be false
    end

end

end
