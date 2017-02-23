class BirthdayValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.blank? || value < 100.years.ago.to_date
      record.errors[attribute] << "is required"
    end
  end
end
