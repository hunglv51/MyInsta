class RelationshipsController < ApplicationController
	def follow_user
		@user = User.find_by! user_name: params[:user_name]
		if current_user.follow @user.id
			create_notification @user
			respond_to do |format|
				format.html { redirect_to root_path }
				format.js
			end
		end
	end
	def unfollow_user
		@user = User.find_by! user_name: params[:user_name]
		if current_user.unfollow @user.id
			respond_to do |format|
				format.html { redirect_to root_path }
				format.js
			end
		end
	end

	private

	def create_notification(user)
	    Notification.create(user_id: @user.id,
	    notified_by_id: current_user.id,
	    post_id: @user.posts.first().id,
	    identifier: -1,
	    notice_type: 'follow')
	end
end
