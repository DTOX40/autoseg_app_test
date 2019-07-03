FactoryBot.define do 
	factory :task do
		title { Faker::lorem.sentence }
		description { Faker::lorem.paragraph }
		deadline { faker::Date.forward }
		done 
		user
  end
end