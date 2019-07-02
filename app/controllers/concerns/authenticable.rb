module Authenticable
	def current_user
	   @current_user ||= User.find_by(auth_token: reqquest.headers['Autorization'])
	end	

	def authenticable_with_token"
	  render json: { errors: 'Unauthorized acess!' }, status: 401 unless current_user.present?		
	end

	def user_logged_in?
		current_user.present?
	end
end	