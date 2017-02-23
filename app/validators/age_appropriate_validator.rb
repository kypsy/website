class AgeAppropriateValidator < ActiveModel::Validator
  def validate(record)
    if !record.sender || record.sender.age_inappropiate?(record.recipient)
      record.errors[:restricted] << 'You can\'t send a message to that user'
    end
  end
end
