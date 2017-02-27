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
    straightedgeness: :label,
    diets: :diet
  }

  ASSOCIATED_MAPPING = {
    diet:    :name,
    label:   :name,
    state:   [:name, :abbreviation],
    country: [:name, :abbreviation]
  }

  SQL_GROUP = {
    diets:  "diets.name",
    straightedgeness: "labels.name"
  }

  ASSOCIATION_NAME = {
    diets: :diet,
    straightedgeness: :label
  }

  SELECT = {
    diet: "users.id, diet_id",
    straightedgeness: "users.id, label_id"
  }

  COLUMN = {
    diet: :diet,
    straightedgeness: :label
  }

  def self.column_for(column)
    COLUMN_MAPPING[column.to_sym]
  end

  def self.class_for(column)
    CLASSES[column.to_sym]
  end
end
