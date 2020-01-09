require 'rails_helper'

describe Loan, type: :model do

  let!(:loan) { FactoryBot.create(:loan) }

  it 'has a valid factory' do
    expect(loan).to be_valid
  end

  context 'validations' do

	  context 'presence' do

		  it 'should be invalid with any empty field' do
        loan.name = nil
        expect(loan).to_not be_valid

        loan.name = 'Test Name'
        loan.principle = nil
        expect(loan).to_not be_valid

        loan.principle = 1000
        loan.interest = nil
        expect(loan).to_not be_valid

        loan.interest = 4.5
			  loan.payment = nil
			  expect(loan).to_not be_valid

        loan.payment = 85
        expect(loan).to be_valid
		  end

	  end

	  context 'length' do

		  it 'should be invalid if not correct length' do
			  loan.name = 'a'
			  expect(loan).to_not be_valid

			  loan.name = 'x'*150
			  expect(loan).to_not be_valid

			  loan.name = 'Test Name'
			  expect(loan).to be_valid
		  end

	  end

	  context 'numericality' do

		  context 'integer only' do

			  it 'should be invalid with non-integer values' do
				  loan.principle = 1000.50
				  expect(loan).to_not be_valid

				  loan.principle = 1000
				  expect(loan).to be_valid
			  end

		  end

		  context 'non-number values' do

			  it 'should be invalid with non-number values' do
				  loan.principle = 'test'
				  expect(loan).to_not be_valid

          loan.principle = 1000
          loan.interest = 'test'
          expect(loan).to_not be_valid

          loan.interest = 4.5
          loan.payment = 'test'
          expect(loan).to_not be_valid

          loan.payment = 85
          expect(loan).to be_valid
			  end

		  end

		  context 'greater than zero' do

			  it 'should be invalid with negative or zero values' do
          loan.principle = -1
          expect(loan).to_not be_valid

          loan.principle = 1000
          loan.interest = -1
          expect(loan).to_not be_valid

          loan.interest = 4.5
          loan.payment = -1
          expect(loan).to_not be_valid

          loan.payment = 85
          expect(loan).to be_valid
			  end

		  end

		  context 'principle and payment' do

        context 'less than ten million' do

          it 'should be invalid with values greater than ten million' do
            loan.principle = 15_000_000
            expect(loan).to_not be_valid

            loan.principle = 1000
            loan.payment = 15_000_000
            expect(loan).to_not be_valid

            loan.payment = 85
            expect(loan).to be_valid
          end

        end

		  end

		  context 'interest' do

			  context 'less than twenty five' do

				  it 'should be invalid with value greater than twenty five' do
					  loan.interest = 75.0
					  expect(loan).to_not be_valid

					  loan.interest = 4.5
					  expect(loan).to be_valid
				  end

        end

      end

    end

  end

  context '#payoff data' do

	  context 'creating payoff data' do

		  let!(:easy_loan) { FactoryBot.create(:loan, principle: 12, interest: 10.0, payment: 2) }

		  it 'should return properly formatted data' do
			  expected = [[Time.zone.today, 12.0],
			              [Time.zone.today + 3.months, 4.3],
			              [Time.zone.today + 6.months, 0]]
			  expect(easy_loan.payoff_data).to match_array(expected)
		  end

    end

  end

end
