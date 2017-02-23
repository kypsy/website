class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if !EmailAddressValidator.validate_addr(value,true)
      record.errors[attribute] << "is not valid"
    end
  end
end
