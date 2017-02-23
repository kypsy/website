class BookmarksController < ApplicationController
  before_action :require_login
  before_action :find_user_by_username
  respond_to :html, :json
  def create
    bookmark = current_user.bookmarks.find_or_initialize_by(bookmarkee_id: @user.id)
    if bookmark.save
      respond_to do |format|
        format.html { redirect_to back_or(person_path(@user.username)), notice: "Bookmark added."}
        format.json { render json: @user.as_json }
      end
    else
      redirect_to back_or(root_path), notice: "There was a problem bookmarking this user. Maybe, try it again?"
    end
  end

  def destroy
    @bookmarks = current_user.bookmarks.where(bookmarkee_id: @user.id)
    @bookmarks.destroy_all
    respond_with(@user, location: back_or(root_path))
  end
end
