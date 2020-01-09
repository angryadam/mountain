class Loan < ApplicationRecord
  belongs_to :provider
  validates :name, :principle, :interest, :payment, presence: true
  validates :name, length: { minimum: 2, maximum: 100 }
  validates :principle, numericality: { only_integer: true }
  validates :principle, :payment, numericality: { greater_than: 0, less_than: 10_000_000 }
  validates :interest, numericality: { greater_than: 0, less_than: 25.0 }

  def payoff_data
    create_payoff_data(principle, payment)
  end

  private

  def create_payoff_data(debt, payment, num_months=0, result=[[Time.zone.today, debt]])
    monthly_interest = debt * monthly_interest_percentage
    total = ((debt + monthly_interest) - payment).round(2)
    if total <= 0
      result << [Time.zone.today + num_months.months, 0]
      return result
    end
    result << [Time.zone.today + num_months.months, total] if (num_months > 0 && num_months % 3 == 0)
    create_payoff_data(total, payment, num_months + 1, result)
  end

  def monthly_interest_percentage
    (self.interest / 100) / 12.0
  end
end
