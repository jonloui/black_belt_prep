class EventsController < ApplicationController
  def index
  	if signed_in? == false
  		redirect_to "/"
  	else
  		@user = current_user #helper function
      @events = Event.joins(:user).select("events.*, users.first_name, users.last_name");
  		# @events = Event.joins("LEFT JOIN attendances ON attendances.event_id = events.id")
  		# 				.select("events.*, attendances.user_id AS attendances_user_id")
  		# 				# .where("attendances.user_id = #{current_user.id}")
      @events_attending = User.find(current_user.id).attendances.select("event_id");

  		#.group_by("events.id")
  		@new_event = Event.new
  		# render json: @events
  		# render text: @user.state
  	end
  end

  # GET /users/1/edit
  def edit
    @event = Event.find(params[:id])
    redirect_to "/events/index" if signed_in? == false or current_user[:id] != @event[:user_id]
  end

  def create
  	@event_result = User.find(current_user.id).events.new(event_params)
  	
  	if @event_result.save
  		redirect_to events_path
  	else
  		flash[:edit_errors] = @event_result.errors.full_messages
  		redirect_to events_path
  	end
  end

  def show
  	if signed_in? == false
  		redirect_to "/"
  	else
  		@user = current_user #helper function
  		@event = Event.joins(:user).select("events.*, users.first_name, users.last_name").where("events.id = #{params[:id]}")
  		@total_people = Event.find(params[:id]).attendances.count
  		@attendees = Attendance.select("users.first_name, users.last_name, users.location, users.state").joins(:user).where(event_id: params[:id])
  		@comments = Comment.joins(:user).select("comments.text, users.first_name").where("comments.event_id = #{params[:id]}")
  		# Event.find(params[:id]).
  		# sort_by("comments.created_at").
  		# render json: @comments
  	end
  end

  def update
  	@event = Event.find(params[:id])
    if @event.update(event_params)
      redirect_to events_index_path
    else
      flash[:edit_errors] = @event.errors.full_messages
      redirect_to "/events/#{params[:id]}/edit"
    end
  end

  def destroy
  	# destroy comments relating to this event!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  	Event.find(params[:id]).attendances.destroy_all
  	Event.find(params[:id]).destroy
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:name, :date, :location, :state)
    end
end
