FactoryBot.define do
	factory :loan do
		association :provider
		sequence :name do |n|
			"Loan #{n}"
		end

		principle { 1000 }
		interest { 4.5 }
		payment { 75.0 }
	end
end
