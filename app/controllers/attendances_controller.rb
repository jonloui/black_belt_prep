class AttendancesController < ApplicationController
	def create
		# render text: current_user.id
		User.find(current_user.id).attendances.create(event_id: params[:id])
		redirect_to "/events/index"
	end

	def destroy
		@record = User.find(current_user.id).attendances.where("event_id = #{params[:id]}")
		Attendance.find(@record[0][:id]).destroy
		redirect_to "/events/index"
	end
end
