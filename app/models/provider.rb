class Provider < ApplicationRecord
	belongs_to :user
	has_many :loans, dependent: :destroy
	accepts_nested_attributes_for :loans, reject_if: :all_blank, allow_destroy: true

	LOAN_LIMIT_NUM = 5

	validates :name, presence: true, length: { minimum: 2, maximum: 100 }
	validates :loans, presence: true
	validate :loans_per_provider_limit

	default_scope { order(name: :asc) }

	def chart_payoff_data
		loans.map do |loan|
			{ name: loan.name.titleize, data: loan.payoff_data }
		end
	end

	def payoff_date
		loans_payoff_dates = loans.map { |loan| { name: loan.name, date: loan.payoff_date } }

		final_date = {}
		loans_payoff_dates.each { |date_data| final_date = date_data if date_data[:date] > (final_date[:date] || Time.zone.now) }

		final_date
	end

	def total_amount_owed
		loans.sum(&:principle)
	end

	private

	def loans_per_provider_limit
		errors.add(:base, "A single provider can only have up to #{LOAN_LIMIT_NUM} loans.") if loans.size > LOAN_LIMIT_NUM
	end
end
