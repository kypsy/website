class Admin::RedFlagsController < AdminController
  def index
    @red_flags = RedFlag.group(:slug).count(:id).sort_by {|slug,count| count }.reverse
    @flagged_users  = @red_flags.reject{ |r| r.first =~ /photo/ }
    @flagged_photos = @red_flags.reject{ |r| r.first =~ /user/  }
  end
  
  def show
    @red_flags = RedFlag.includes(:reporter).where(slug: params[:id])
    @object    = @red_flags.take.flaggable
  end
end
