module ProviderHelper

  def format_last_loan_data(name:, date:)
    return 'N/A' unless name.present? && date.present?

    "#{name.titleize} / #{format_date(date)}"
  end
end
