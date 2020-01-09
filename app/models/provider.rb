class Provider < ApplicationRecord
	has_many :loans
	accepts_nested_attributes_for :loans, reject_if: :all_blank, allow_destroy: true

	validates :name, presence: true, length: { minimum: 2, maximum: 100 }

	def chart_payoff_data
		loans.map do |loan|
			{ name: loan.name.titleize, data: loan.payoff_data }
		end
	end
end
