class Admin::DashboardController < AdminController
  def index
    @red_flags = RedFlag.group(:slug).count(:id).sort_by {|slug, count| count }.reverse
    @flagged_users  = @red_flags.reject{ |r| r.first =~ /photo/ }
    @flagged_photos = @red_flags.reject{ |r| r.first =~ /user/  }
  end
end
