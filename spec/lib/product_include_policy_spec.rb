describe ProductIncludePolicy do
  describe "#words_okay?" do
    it "should not be if the product has a bad word" do
      policy = ProductIncludePolicy.new({ "title" => 'Examenbundel enzo' })
      policy.send(:words_okay?).should be_false
    end

    it "should not be if the product has no bad words" do
      policy = ProductIncludePolicy.new({ "title" => 'Bla die blas' })
      policy.send(:words_okay?).should be_true
    end
  end
end
