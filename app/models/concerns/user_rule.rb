module UserRule

  ALLOWED_SEARCH_COLUMNS = %w(labels)
  DISALLOWED_COLUMNS = [
    :id,
    :visible,
    :bio,
    :canonical_username,
    :name,
    :email,
    :created_at,
    :updated_at,
    :agreed_to_terms_at,
    :settings,
    :auth_token
  ]

  COLUMN_MAPPING = {
    lable: :label
  }

  ASSOCIATED_MAPPING = {
    label: :name
  }

  SQL_GROUP = {
    labels: "labels.name"
  }

  ASSOCIATION_NAME = {
    labels: :label
  }

  SELECT = {
    label: "users.id, label_id"
  }

  COLUMN = {
    label: :label
  }

  def self.column_for(column)
    COLUMN_MAPPING[column.to_sym]
  end

  def self.class_for(column)
    CLASSES[column.to_sym]
  end
end
