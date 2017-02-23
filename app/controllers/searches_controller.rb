class SearchesController < ApplicationController
  before_action :require_login, only: [:index]
  before_action :search_term, only: :show

  def index
    @title_text = params[:column].titleize
    @groups     = current_user.viewable_users.group_by_column(params[:column].to_sym)
    @total      = @groups.sum(&:last)
  end

  private

  def search_term
    return unless params[:search]

    search = params[:search].split("/", 2)
    @search, @query, @column = if search.count.even?
      [Hash[*search], search.last, search.first]
    else
      [search.first, search.first, nil]
    end

    @column = nil unless User::ALLOWED_SEARCH_COLUMNS.include? @column
  end
end
