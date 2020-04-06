require 'rails_helper'

describe User, type: :model do

	let!(:user) { FactoryBot.create(:user, :with_providers) }

	it 'has a valid factory' do
		expect(user).to be_valid
	end

	context 'validations' do

		context 'providers' do

			context 'number of providers' do

				it 'should be invalid if more than 5 providers exist for this user' do
					expect(user.providers.size).to eq(2)
					expect(user).to be_valid

					FactoryBot.create_list(:provider, 5, user: user)
					expect(user.providers.size).to eq(7)
					expect(user).to_not be_valid

					# custom validation error message
					expect(user.errors.messages[:base]).to match_array(['You can only have up to 5 providers.'])
				end

			end

		end

	end

	context '#final_payoff_info' do

		let(:loan) { user.providers.first.loans.first }

		it 'should return name and date for the last loan to be paid off' do
			loan.update(principle: 3000)
			expect(user.final_payoff_info).to eq({ name: loan.name,
			                                       date: Time.zone.today.beginning_of_month + 44.months })
		end

	end

	context '#total_amount_owed' do

		it 'should return summed principle amount for all loans' do
			expect(user.total_amount_owed).to eq(4000)
		end

	end

end
