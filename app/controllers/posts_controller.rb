class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy, :like, :unlike]
  before_action :authenticate_user!
  before_action :owner_post, only: [:edit, :update, :destroy]
  

  def index
    
    @posts = Post.of_followed_users(current_user.following).order('created_at DESC').page params[:page]
    respond_to do |format|
      format.html
      format.js
    end

  end

  def show
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save 
      flash[:success] = "Your post has been created!"
      redirect_to profile_path(current_user.user_name)
    else
      flash.now[:alert] = "Your new post couldn't be created!  Please check the form."
      render :new
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      flash[:success] = "Post updated."
      redirect_to posts_path
    else
      flash.now[:alert] = "Update failed.  Please check the form."
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to root_path
  end

  def like
    if @post.liked_by current_user
      create_notification @post
      respond_to do |format|
        format.html {redirect_back(fallback_location: root_path)}
        format.js
      end
      
    end
    
  end

  def unlike
    if @post.unliked_by current_user
      respond_to do |format|
        format.html {redirect_back(fallback_location: root_path)}
        format.js
      end
    end
    
  end

  def browse
    @posts = Post.all.order('created_at DESC').page params[:page]
    respond_to do |format|
      format.html 
      format.js
    end
  end

  private
  def owner_post
    unless @post.user == current_user
      flash[:alert] = "That post doesn't belong to you!"
      redirect_to root_path 
    end
  end

  def post_params
    params.require(:post).permit(:image, :caption)
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def create_notification(post)
   if @post.user.id != current_user.id
    Notification.create(user_id: @post.user.id,
    notified_by_id: current_user.id,
    post_id: @post.id,
    identifier: -1,
    notice_type: 'like')
    end
  end

end
