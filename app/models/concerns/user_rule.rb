module UserRule

  ALLOWED_SEARCH_COLUMNS = %w(diets labels)
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
    :birthday,
    :settings,
    :auth_token
  ]

  COLUMN_MAPPING = {
    lable: :label,
    diets: :diet
  }

  ASSOCIATED_MAPPING = {
    diet:    :name,
    label:   :name
  }

  SQL_GROUP = {
    diets:  "diets.name",
    labels: "labels.name"
  }

  ASSOCIATION_NAME = {
    diets: :diet,
    labels: :label
  }

  SELECT = {
    diet: "users.id, diet_id",
    label: "users.id, label_id"
  }

  COLUMN = {
    diet: :diet,
    label: :label
  }

  def self.column_for(column)
    COLUMN_MAPPING[column.to_sym]
  end

  def self.class_for(column)
    CLASSES[column.to_sym]
  end
end
