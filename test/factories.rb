FactoryGirl.define do
  factory :user do
    artists Set.new(["artist1"])
  end

  factory :knewton do
    users { 
      [
        User.new(["artist1", "artist2"]),
        User.new(["artist1", "artist2", "artist3"])
      ] 
    }

    # artists_dict  "hello"
    
  end
end
