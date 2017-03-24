module UserRule

  ALLOWED_SEARCH_COLUMNS = %w()
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
    interests:  :desired_interests,
    activities: :desired_activities,
    age:        :age_range,
  }

  ASSOCIATED_MAPPING = {
    desired_interests:  :name,
    desired_activities: :name,
    age_range:          :name,
  }

  SQL_GROUP = {
    interests:  "interests.name",
    activities: "activities.name",
    age_ranges: "age_ranges.name"
  }

  ASSOCIATION_NAME = {
    interests:  :interest,
    activities: :activity,
    age_ranges: :age_range
  }

  SELECT = {
    interest:  "users.id, interest_id",
    activity:  "users.id, activity_id",
    age_range: "users.id, age_range_id"
  }

  COLUMN = {
    interest:  :interest,
    activity:  :activity,
    age_range: :age_range
  }

  def self.column_for(column)
    COLUMN_MAPPING[column.to_sym]
  end

  def self.class_for(column)
    CLASSES[column.to_sym]
  end
end
