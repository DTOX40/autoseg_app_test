FactoryBot.define do 
	factory :task do
		title { Faker::lorem.sentence }
		description { Faker::Lorem.paragraph }
		deadline { Faker::Date.forward }
		done 
		user
  end
end