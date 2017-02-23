module SearchesHelper
  def groups_of_one?
    @title_text.downcase =~ /gender/
  end
end
