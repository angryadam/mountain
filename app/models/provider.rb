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

	private

	def loans_per_provider_limit
		errors.add(:base, "A single provider can only have up to #{LOAN_LIMIT_NUM} loans.") if loans.size > LOAN_LIMIT_NUM
	end
end
