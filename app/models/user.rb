class User < ApplicationRecord
  include Clearance::User

  has_many :providers, dependent: :destroy
  has_many :loans, through: :providers

  PROVIDER_LIMIT_NUM = 5

  validate :providers_per_user_limit

  def final_payoff_info
    provider_payoff_dates = providers.map(&:payoff_date)

    payoff_date = {}
    provider_payoff_dates.each { |date_data| payoff_date = date_data if date_data[:date] > (payoff_date[:date] || Time.zone.now) }

    payoff_date
  end

  def total_amount_owed
    providers.sum(&:total_amount_owed)
  end

  private

  def providers_per_user_limit
    errors.add(:base, "You can only have up to #{PROVIDER_LIMIT_NUM} providers.") if providers.size > PROVIDER_LIMIT_NUM
  end
end
