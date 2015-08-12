class CommentsController < ApplicationController
	def create
		@comment = User.find(current_user.id).comments.new(comment_params)

		# render json: @event
		# render text: params[:comment][:event_id]
		if @comment.save
			redirect_to "/events/"+params[:comment][:event_id].to_s
		else
			flash[:comment_error] = @comment.errors.full_messages
			redirect_to "/events/"+params[:comment][:event_id].to_s
		end
	end

	private
    # Never trust parameters from the scary internet, only allow the white list through.
	    def comment_params
	      params.require(:comment).permit(:text, :event_id)
	    end
end
