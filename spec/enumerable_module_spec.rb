require './enumerable_module'

ARRAY_SIZE = 50
LOWEST_VALUE = 0
HIGHEST_VALUE = 9

describe Enumerable do
    let(:array) { Array.new(ARRAY_SIZE) {rand(LOWEST_VALUE...HIGHEST_VALUE)}} 
    let(:array_clone) { array.clone } 
    let(:block) { proc {|value| value + 1} } 

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

end
