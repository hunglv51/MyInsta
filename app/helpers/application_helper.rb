module ApplicationHelper
	def alert_for(flash_type)
		{ success: 'alert-success',
			error: 'alert-danger',
			alert: 'alert-warning',
			notice: 'alert-info'
		}[flash_type.to_sym] || flash_type.to_s
	end

	def form_image_select(post)
	return image_tag post.image.url,id: 'image-preview',class: 'img-responsive' if post.image.exists?
	image_tag 'placeholder.jpg', id: 'image-preview', class: 'img-responsive'
	end

	

	def profile_avatar_select(user)
		if user.avatar.exists?	
			return image_tag user.avatar.url(:medium),
			id: 'image-preview',
			class: 'img-responsive img-circle profile-image'	
		else	
			return image_tag 'default-avatar.jpg', id: 'image-preview',
			class: 'img-responsive img-circle profile-image'
		end
	end

	def icon_avatar_select(user)
		if user.avatar.exists?	
			return image_tag user.avatar.url(:thumb),
			class: 'img-circle'	
		else	
			return image_tag 'icon-default-avatar.jpg', 
			class: 'img-circle'
		end
	end
end
