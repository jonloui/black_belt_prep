class SessionsController < ApplicationController
	def create
		#this references the function we made in user.rb
		user = User.authenticate(params[:session][:email], params[:session][:password])
		
		if user.nil?
			flash[:session_errors] = "Login attempt failed!"
			redirect_to "/"
		else
			sign_in user #helper function
			redirect_to "/events/index"
		end
	end

	def destroy
		sign_out #helper function
		redirect_to "/"
	end
end
