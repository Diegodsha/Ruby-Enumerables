require './enumerable_module'

ARRAY_SIZE = 50
LOWEST_VALUE = 0
HIGHEST_VALUE = 9

describe Enumerable do
    let(:array) { Array.new(ARRAY_SIZE) {rand(LOWEST_VALUE...HIGHEST_VALUE)}} 
    let(:array_clone) { array.clone } 
    let(:block) { proc {|value| value + 1} } 
    let(:block_index) { proc {|value, index| value + index} } 
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

end
