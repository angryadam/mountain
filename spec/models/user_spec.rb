require 'rails_helper'

describe User, type: :model do

	let!(:user) { FactoryBot.create(:user, :with_providers) }

	it 'has a valid factory' do
		expect(user).to be_valid
	end

	context 'validations' do

		context 'providers' do

			context 'number of providers' do

				it 'should be invalid if more than 10 loans exist for this provider' do
					expect(user.providers.size).to eq(2)
					expect(user).to be_valid

					FactoryBot.create_list(:provider, 25, user: user)
					expect(user.providers.size).to eq(27)
					expect(user).to_not be_valid

					# custom validation error message
					expect(user.errors.messages[:base]).to match_array(['You can only have up to 25 providers.'])
				end

			end

		end

	end

end
