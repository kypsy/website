class UsersSerializer
  def initialize(collection)
    @collection = collection
  end

  def to_h
    {users: collection}
  end

  def collection
    @collection.map {|user| {id: user.id} }
  end

end
