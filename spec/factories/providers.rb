FactoryBot.define do
	factory :provider do
		association :user

		sequence(:name) { |n| "Test Provider #{n}" }

		before(:create) do |provider|
			provider.save(validate: false)
			2.times { create(:loan, provider: provider) }
		end

	end
end
