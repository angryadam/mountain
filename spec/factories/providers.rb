FactoryBot.define do
	factory :provider do
		sequence(:name) { |n| "Test Provider #{n}" }
	end

	trait :with_loans do
		after :build do |provider|
			2.times do
				create(:loan, provider: provider)
			end
		end
	end
end
