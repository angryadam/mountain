class Loan < ApplicationRecord
  belongs_to :provider
  validates :name, :principle, :interest, :payment, presence: true
  validates :name, length: { minimum: 2, maximum: 100 }
  validates :principle, numericality: { only_integer: true }
  validates :principle, :payment, numericality: { greater_than: 0, less_than: 10_000_000 }
  validates :interest, numericality: { greater_than: 0, less_than: 25.0 }

  default_scope { order(name: :asc) }

  validate :not_upside_down

  def payoff_data
    create_payoff_data(principle, payment)
  end

  def payoff_date
    payoff_data.last.first
  end

  private

  def create_payoff_data(debt, payment, num_months=1, result=[[Time.zone.today.beginning_of_month, debt]])
    current_principle = monthly_total(debt: debt, payment: payment)

    if current_principle <= 0
      result << [Time.zone.now.beginning_of_month + num_months.months, 0]
      return result
    end
    result << [Time.zone.now.beginning_of_month + num_months.months, current_principle]
    create_payoff_data(current_principle, payment, num_months + 1, result)
  end

  def monthly_total(debt:, payment:)
    monthly_interest_percent = (self.interest / 100) / 12.0
    monthly_interest = debt * monthly_interest_percent
    ((debt + monthly_interest) - payment).round(2)
  end

  def loan_is_upside_down?
    return unless self.principle && self.payment && self.interest

    self.principle <= monthly_total(debt: self.principle, payment: self.payment)
  end

  def not_upside_down
    errors.add(:will, 'never be paid off based on entered interest and payment') if loan_is_upside_down?
  end
end
