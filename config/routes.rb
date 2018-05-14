Rails.application.routes.draw do
  get 'relationships/follow_user'
  get 'relationships/unfollow_user'
  get '/findFriend', to: 'profiles#findFriend'
  get '/search', to: 'profiles#search'
  post ':user_name/follow_user', to: 'relationships#follow_user', as: :follow_user
  post ':user_name/unfollow_user', to: 'relationships#unfollow_user', as: :unfollow_user
  
  get 'notifications/:id/link_through', to:'notifications#link_through', as: :link_through
  get 'notifications', to: 'notifications#index' 
  get '/refresh', to: 'notifications#refresh'
  # get 'profiles/show'
  
  
	get '/browse', to: 'posts#browse', as: :browse_posts		
	resources :posts do
		resources :comments
		member do
			get 'unlike', to: "posts#unlike"
			get 'like', to: "posts#like"
    	
		end
	end

	root 'posts#index'
	
	devise_for :users, :controllers => { registrations: 'registrations' }
	
	get ':user_name', to: 'profiles#show', as: :profile
	get ':user_name/edit', to: 'profiles#edit', as: :edit_profile
	patch ':user_name/update', to: 'profiles#update', as: :update_profile
	get  ':user_name/followers', to: 'profiles#followers', as: :get_followers
	get  ':user_name/followings', to: 'profiles#followings', as: :get_followings
	
end
