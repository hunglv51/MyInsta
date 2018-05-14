class ProfilesController < ApplicationController
  	before_action :set_user
  	before_action :authenticate_user!
	  before_action :owned_profile, only: [:edit, :update]
  def show
  	@posts = @user.posts.order('created_at DESC').page params[:page]
    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
  end
  
  def update
  	if @user.update(profile_params)
  		flash[:success] = "Your profile has been updated."
  		redirect_to profile_path(@user.user_name)
	else
		@user.errors.full_messages
		flash[:error] = @user.errors.full_messages
		render :edit
	end
  end

  def followers
    @followers = @user.followers
  end

  def followings
    @followings = @user.following
  end

  def findFriend
    @friends = nil
    unless params[:friend_name].blank?
      @friends = User.where("user_name like ?", "#{params[:friend_name]}%")
     end
  end

  def search
    @friends = nil
    unless params[:friend_name].blank?
      @friends = User.where("user_name like ?", "#{params[:friend_name]}%").first(5)
     end
     render json: @friends.as_json(only: [:user_name, :id])
     
  end

  private
  def profile_params
  	params.require(:user).permit(:avatar, :bio)
  end
  def owned_profile
  	unless current_user == @user
  		flash[:alert] = "This profile doesn't belong to you!!!"
  		redirect_to root_path
  	end
  end
	def set_user
		@user = User.find_by(user_name: params[:user_name])
	end  
end
