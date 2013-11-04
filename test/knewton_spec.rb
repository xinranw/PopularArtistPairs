# knewton_spec.rb
require_relative '../knewton'
require 'factory_girl'

FactoryGirl.find_definitions

describe User, ".new" do
  describe "nil user" do
    user = User.new nil
    it 'has no artists' do
      user.number_of_artists.should eql(0)
    end
  end

  describe "with multiple artists" do
    user = User.new ["a1", "a2"]
    it 'has more than one artist' do
      user.number_of_artists.should be > 1
    end
  end
end

describe Knewton do
  knewton = FactoryGirl.build(:knewton)

  describe 'fills artists then trims' do
    knewton.fillArtistsDict
    knewton.trimDict 2
    it 'contains artist2' do
      knewton.artists_dict.has_key?("artist2").should be_true
    end
    it 'removes artists that occur less than 2 times' do
      knewton.artists_dict.has_key?("artist2").should be_true
      knewton.artists_dict.has_key?("artist3").should_not be_true
    end
  end
end