class EventsController < Sinatra::Base
	enable :method_override
	helpers Sinatra::ApiRequest

	before do
		content_type :json
	end

	helpers do
		def user_id
			api_request[:params][:user_id]
		end
		
		def event_id
			api_request[:params][:id]
		end

		def attendee_id
			api_request[:params][:attendee_id]
		end
	end

	#EVENT MODEL CRUD

	# Get all event records
	get '/' do
		events ||= Event.all() || halt(api_error 1001)
		events.to_json
	end

	# Get specific event record
	get '/:id' do
		event ||= Event.get(event_id) || halt(api_error 1001)
		event.to_json
	end

	# Create new event record
	post '/' do
		user_id = api_request[:json_body]["user_id"]
		attributes = [
			:title => api_request[:json_body]["title"],
	  	:address => api_request[:json_body]["address"],
	  	:lat => api_request[:json_body]["lat"],
	  	:lng => api_request[:json_body]["lng"],
	  	:start_date => api_request[:json_body]["start_date"],
			:finish_date => api_request[:json_body]["finish_date"],
  		:description => api_request[:json_body]["description"],
		]
		user ||= User.get(user_id) || halt(api_error 1001)
		event = user.events.new
		event.attributes = attributes
		halt(api_error 1002) unless event.save
		event.to_json
	end

	# Update existing event record
	put '/:id' do
		user_id = api_request[:json_body]["user_id"]
		user ||= User.get(user_id) || halt(api_error 1001)
		attributes = [
			:title => api_request[:json_body]["title"],
	  	:address => api_request[:json_body]["address"],
	  	:lat => api_request[:json_body]["lat"],
	  	:lng => api_request[:json_body]["lng"],
	  	:start_date => api_request[:json_body]["start_date"],
			:finish_date => api_request[:json_body]["finish_date"],
  		:description => api_request[:json_body]["description"],
  		:user => user
		]
		halt(api_error 1003) unless event.save
		event.to_json
	end

	# Delete event record
	delete '/:id' do
		event_id = api_request[:params][:id]
		Event.get(event_id).destroy()
	end

	# EVENT ATTENDEES
	
	# Get all users records attending the event	
	get '/:id/attendees' do
		event ||= Event.get(event_id) || halt(api_error 1001)
		attendees ||= event.attendees.all().user.account || halt(api_error 1001)
		attendees.to_json
	end

	# Get specific user record attending the event 
	get '/:id/attendees/:attendee_id' do
		attendee_id = api_request[:params][:attendee_id]
		event ||= Event.get(event_id) || halt(api_error 1001)
		attendee ||= attendees.get(attendee_id).user.account || halt(api_error 1001)
		attendee.to_json
	end

	# Save users RSVP for event
	post '/:id/attendees' do
		user_id = api_request[:json_body]["user_id"]
		event ||= Event.get(event_id) || halt(api_error 1001)
		user ||= User.get(user_id) || halt(api_error 1001)
		attributes = [:user => user]
		atendee = event.attendees.new 
		halt(api_error 1002) unless attendee.save
		attendee.to_json
	end

	# EVENT COMMENTS

	# Get event comments records
	get '/:id/comments/' do
		event ||= Event.get(event_id) || halt(api_error 1001)
		comments ||= comments.all() || halt(api_error 1001)
		comments.to_json
	end

	# Get specific event comment record
	get '/:id/comments/:comment_id' do
		comment_id = api_request[:params][:comment_id]
		event ||=	Event.get(event_id)
		comment ||= comments.get(comment_id)
		comment.to_json
	end

	# Create comment for an event by a user
	post '/:id/comment' do
		user_id = api_request[:json_body]["user_id"]
		content = api_request[:json_body]["content"]
		user ||= User.get(user_id) || halt(api_error 1001)
		event ||= Event.get(event_id) || halt(api_error 1001)
		attributes = [
			:user => user,
			:content => content
		]
		comment = evnet.comments.new
		comment.attributes = attributes
		halt(1002) unless comment.save
		comment.to_json
	end

	# EVENT SECTIONS

	# Get all event widgets in sections
	get '/:id/sections/' do
		event ||= Event.get(event_id) || halt(api_error 1001)
		widgets ||= event.sections.widget || halt(api_error 1001)
		widgets.to_json
	end

	#Get specific event widget in section
	get '/:id/sections/:section_id' do
		section_id = api_request[:parmas][:section_id]
		event ||= Event.get(event_id) || halt(api_error 1001)
		widget ||= event.sections.get(section_id).widget || halt(api_error 1001)
		widget.to_json
	end

	post '/:id/sections' do
		event ||= Event.get(event_id) || halt(api_error 1001)
		widget_type = api_request[:json_body]["widget_type"]
		widget ||= Widget.first_or_create(:type => widget_type) || halt(api_error 1001)
		attributes = [
			:enable => true,
			:widget => widget
		]
		new_section = event.sections.new
		new_section.attributes = attributes
		halt(api_error 1002) unless new_section.save
		new_section.to_json
	end

end