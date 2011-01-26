require 'spec_helper'

describe Answer do
  it "should create a new instance given valid attributes" do
    Factory.create(:answer)
  end

  describe "#voices" do
    before(:each) do
      @question = Factory(:question)
      @answer = Factory(:answer, :question => @question)
    end

    context "one answer" do
      it "returns the answer user for voices" do
        @answer.voices.should == [@answer.user]
      end

      it "returns the question user for recipient_voices" do
        @answer.recipient_voices.should == [@question.user]
      end
    end

    context "more than one answer" do
      before(:each) do
        @answer2 = Factory(:answer, :question => @answer.question)
        @answer3 = Factory(:answer, :question => @answer.question)
        @answer4 = Factory(:answer, :question => @answer.question, :user => @answer2.user)
      end

      it "returns the answers users for voices" do
        @answer.voices.should == [@answer.user, @answer2.user, @answer3.user]
      end

      it "returns the answers users and question user for recipient voices" do
        @answer.recipient_voices.should == [@answer2.user, @answer3.user, @question.user]
      end
    end

  end

end
