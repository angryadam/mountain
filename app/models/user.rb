class User < ApplicationRecord
  include Clearance::User

  has_many :providers, dependent: :destroy

  validate :providers_per_user_limit

  private

  def providers_per_user_limit
    errors.add(:base, 'You can only have up to 25 providers.') if providers.size > 25
  end
end
