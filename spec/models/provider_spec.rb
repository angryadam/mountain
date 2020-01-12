require 'rails_helper'

describe Provider, type: :model do

	let!(:provider) { FactoryBot.create(:provider, :with_loans) }

	it 'has a valid factory' do
		expect(provider).to be_valid
	end

	context 'validations' do

		context 'name' do

			context 'presence' do

				it 'should be invalid if not present' do
					provider.name = nil
					expect(provider).to_not be_valid

					provider.name = 'Test Name'
					expect(provider).to be_valid
				end

			end

			context 'length' do

				it 'should be invalid if not correct length' do
					provider.name = 'a'
					expect(provider).to_not be_valid

					provider.name = 'x'*150
					expect(provider).to_not be_valid

					provider.name = 'Test Name'
					expect(provider).to be_valid
				end

			end

		end

		context 'loans' do

			context 'number of loans' do

				it 'should be invalid if more than 10 loans exist for this provider' do
					expect(provider.loans.size).to eq(2)
					expect(provider).to be_valid

					FactoryBot.create_list(:loan, 10, provider: provider)
					expect(provider.loans.size).to eq(12)
					expect(provider).to_not be_valid

					# custom validation error message
					expect(provider.errors.messages[:base]).to match_array(['A single provider can only have up to 10 loans.'])
				end

			end

		end

	end

	context '#chart_payoff_data' do

		context 'creating loan payoff data' do

			before(:each) { provider.loans.update_all(principle: 12, interest: 10.0, payment: 2) }

			it 'should return properly formatted data' do
				expected = [{name: provider.loans.first.name,
				             data: [[Time.zone.today, 12.0],
				                    [Time.zone.today + 3.months, 4.3],
				                    [Time.zone.today + 6.months, 0]]},
				            {name: provider.loans.second.name,
				             data: [[Time.zone.today, 12.0],
				                    [Time.zone.today + 3.months, 4.3],
				                    [Time.zone.today + 6.months, 0]]}]

				expect(provider.chart_payoff_data).to match_array(expected)
			end

		end

	end
end
