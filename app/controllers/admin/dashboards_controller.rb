class Admin::DashboardsController < Admin::BaseController
  skip_before_action :require_login
  skip_before_action :check_admin

  def index
    @today = Time.current
    one_week_ago = 1.week.ago.beginning_of_day

    users = User.all
    @users_count = users.count
    @users_count_lastweek = users.where(created_at: one_week_ago..@today).count
    @newmoon_notifications_count = users.where(need_newmoon_msg: 'true').count
    @fullmoon_notifications_count = users.where(need_fullmoon_msg: 'true').count

    wishes = Wish.all
    @wishes_count = wishes.count
    @wishes_count_lastweek = wishes.where(created_at: one_week_ago..@today).count
    
    declarations = Declaration.all
    @declarations_count = declarations.count
    @declarations_count_lastweek = declarations.where(created_at: one_week_ago..@today).count

    @moons = Moon.where(newmoon_time: @today.ago(3.month)..@today.since(3.month)).preload([:zodiac_sign, :wishes])
  end
end
