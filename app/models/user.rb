class User < ApplicationRecord
  include Clearance::User

  has_many :providers, dependent: :destroy

  PROVIDER_LIMIT_NUM = 5

  validate :providers_per_user_limit

  private

  def providers_per_user_limit
    errors.add(:base, "You can only have up to #{PROVIDER_LIMIT_NUM} providers.") if providers.size > PROVIDER_LIMIT_NUM
  end
end
