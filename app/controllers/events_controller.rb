class EventsController < ApplicationController
  
  def new
    @event = Event.new(:end_at => 1.hour.from_now, :period => "Does not repeat")
  end
  
  def create
    if params[:event][:period] == "Does not repeat"
      @event = current_user.events.new(params[:event])
      @event.save
    else
      # @event_series = EventSeries.new(:frequency => params[:event][:frequency], :period => params[:event][:repeats],
      # :start_at => params[:event][:start_at], :end_at => params[:event][:end_at], :all_day => params[:event][:all_day])
      @event_series = current_user.eventSeries.new(params[:event])
      @event_series.save
    end
    
    respond_to do |format|
      format.html { redirect_to project_path(params[:project][:name]) }
      format.js # create.js.erb
    end
  end
  
  def index
    @event = Event.new(:end_at => 1.hour.from_now, :period => "Does not repeat")
    @events = Event.all
    
    respond_to do |format|
      format.html
      format.js # index.js.erb
    end
  end

  def show
    @event = Event.find(params[:id])
    @comment = Comment.new
    @comments = @event.comments
    @events = Event.all
    
    respond_to do |format|
      format.html
      format.js # index.js.erb
    end
  end

  def get_events
    @events = Event.find(:all, :conditions => ["start_at >= '#{Time.at(params['start'].to_i).to_formatted_s(:db)}' and end_at <= '#{Time.at(params['end'].to_i).to_formatted_s(:db)}'"] )
    events = [] 
    @events.each do |event|
      events << {:id => event.id, :title => event.title, :description => event.description || "Some cool description here...", :start => "#{event.start_at.iso8601}", :end => "#{event.end_at.iso8601}", :allDay => event.all_day, :recurring => (event.event_series_id)? true: false}
    end
    render :text => events.to_json
  end
  
  
  def move
    @event = Event.find_by_id params[:id]
    if @event
      @event.start_at = (params[:minute_delta].to_i).minutes.from_now((params[:day_delta].to_i).days.from_now(@event.start_at))
      @event.end_at = (params[:minute_delta].to_i).minutes.from_now((params[:day_delta].to_i).days.from_now(@event.end_at))
      @event.all_day = params[:all_day]
      @event.save
    end
  end
  
  
  def resize
    @event = Event.find_by_id params[:id]
    if @event
      @event.end_at = (params[:minute_delta].to_i).minutes.from_now((params[:day_delta].to_i).days.from_now(@event.end_at))
      @event.save
    end    
  end
  
  def edit
    @event = Event.find_by_id(params[:id])
  end
  
  def update
    @event = Event.find_by_id(params[:event][:id])
    if params[:event][:commit_button] == "Update All Occurrence"
      @events = @event.event_series.events #.find(:all, :conditions => ["start_at > '#{@event.start_at.to_formatted_s(:db)}' "])
      @event.update_events(@events, params[:event])
    elsif params[:event][:commit_button] == "Update All Following Occurrence"
      @events = @event.event_series.events.find(:all, :conditions => ["start_at > '#{@event.start_at.to_formatted_s(:db)}' "])
      @event.update_events(@events, params[:event])
    else
      @event.attributes = params[:event]
      @event.save
    end

    render :update do |page|
      page << "$('#calendar').fullCalendar( 'refetchEvents' )"
      page << "$('#desc_dialog').dialog('destroy')" 
    end
    
  end  
  
  def destroy
    @event = Event.find_by_id(params[:id])
    if params[:delete_all] == 'true'
      @event.event_series.destroy
    elsif params[:delete_all] == 'future'
      @events = @event.event_series.events.find(:all, :conditions => ["start_at > '#{@event.start_at.to_formatted_s(:db)}' "])
      @event.event_series.events.delete(@events)
    else
      @event.destroy
    end
    
    render :update do |page|
      page<<"$('#calendar').fullCalendar( 'refetchEvents' )"
      page<<"$('#desc_dialog').dialog('destroy')" 
    end
    
  end
  
end
