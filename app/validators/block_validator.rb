class BlockValidator < ActiveModel::Validator
  def validate(record)
    if record.sender.block_with_user?(record.recipient)
      record.errors[:restricted] << "@#{record.recipient.username} is not available to message"
    end
  end
end
