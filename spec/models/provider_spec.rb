require 'rails_helper'

describe Provider, type: :model do

	let!(:provider) { FactoryBot.create(:provider, :with_loans) }

	it 'has a valid factory' do
		expect(provider).to be_valid
	end

	context 'validations' do

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
