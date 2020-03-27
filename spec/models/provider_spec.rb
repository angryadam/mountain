require 'rails_helper'

describe Provider, type: :model do

	let!(:provider) { FactoryBot.create(:provider) }

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

				it 'should be invalid if more than 5 loans exist for this provider' do
					expect(provider.loans.size).to eq(2)
					expect(provider).to be_valid

					5.times { provider.loans << create(:loan, provider: provider) }
					expect(provider.loans.size).to eq(7)
					expect(provider).to_not be_valid

					# custom validation error message
					expect(provider.errors.messages[:base]).to match_array(['A single provider can only have up to 5 loans.'])
				end

			end

		end

	end

	context '#chart_payoff_data' do

		context 'creating loan payoff data' do

			before(:each) { provider.loans.update(principle: 12, interest: 2.0, payment: 5) }

			it 'should return properly formatted data' do
				expected = [{name: provider.loans.first.name,
				             data: [[Time.zone.today.beginning_of_month, 12.0],
				                    [Time.zone.today.beginning_of_month + 1.month, 7.02],
				                    [Time.zone.today.beginning_of_month + 2.months, 2.03],
				                    [Time.zone.today.beginning_of_month + 3.months, 0]]},
				            {name: provider.loans.second.name,
				             data: [[Time.zone.today.beginning_of_month, 12.0],
				                    [Time.zone.today.beginning_of_month + 1.month, 7.02],
				                    [Time.zone.today.beginning_of_month + 2.months, 2.03],
				                    [Time.zone.today.beginning_of_month + 3.months, 0]]}]
				expect(provider.chart_payoff_data).to match_array(expected)
			end

		end

	end
end
