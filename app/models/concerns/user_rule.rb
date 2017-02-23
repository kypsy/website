module UserRule

  ALLOWED_SEARCH_COLUMNS = %w(me_gender diets labels)
  DISALLOWED_COLUMNS = [
    :id,
    :me_gender_map,
    :you_gender_map,
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
    gender: :me_gender,
    genders: :me_gender,
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
    straightedgeness: "labels.name",
    genders: "me_gender"
  }

  ASSOCIATION_NAME = {
    diets: :diet,
    genders: nil,
    straightedgeness: :label
  }

  SELECT = {
    diet: "users.id, diet_id",
    gender: "users.id, me_gender",
    straightedgeness: "users.id, label_id"
  }

  COLUMN = {
    diet: :diet,
    gender: :me_gender,
    straightedgeness: :label
  }

  def self.column_for(column)
    COLUMN_MAPPING[column.to_sym]
  end

  def self.class_for(column)
    CLASSES[column.to_sym]
  end
end
