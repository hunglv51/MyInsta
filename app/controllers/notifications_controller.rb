class NotificationsController < ApplicationController
	protect_from_forgery except: :refresh
  def link_through
  	@notification = Notification.find(params[:id])
	@notification.update read: true
	if @notification.notice_type == "follow"
		redirect_to profile_path @notification.notified_by.user_name
	else
		redirect_to post_path @notification.post
	end
  end
  def index
	@notifications = current_user.notifications.all.order('created_at DESC')
  end
  def refresh
  	respond_to do |format|
  		format.js
  	end
  end
end
