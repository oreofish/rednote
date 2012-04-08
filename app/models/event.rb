# == Schema Information
#
# Table name: events
#
#  id              :integer(4)      not null, primary key
#  user_id         :integer(4)
#  project_id      :integer(4)
#  event_series_id :integer(4)
#  title           :string(255)
#  description     :text
#  start_at        :datetime
#  end_at          :datetime
#  all_day         :boolean(1)      default(FALSE)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#

class Event < ActiveRecord::Base
  attr_accessor :period, :frequency, :commit_button
  belongs_to :event_series
  acts_as_audited
  acts_as_commentable

  validates  :title, :presence => true

  REPEATS = [ "Does not repeat",
              "Daily",
              "Weekly",
              "Monthly",
              "Yearly" ]

  def validate
    if (start_at >= end_at) and !all_day
      errors.add_to_base("Start Time must be less than End Time")
    end
  end

  def update_events(events, event)
    events.each do |e|
      begin
        st, et = e.start_at, e.end_at
        e.attributes = event
        if event_series.period.downcase == 'monthly' or event_series.period.downcase == 'yearly'
          nst = DateTime.parse("#{e.start_at.hour}:#{e.start_at.min}:#{e.start_at.sec}, #{e.start_at.day}-#{st.month}-#{st.year}")  
          net = DateTime.parse("#{e.end_at.hour}:#{e.end_at.min}:#{e.end_at.sec}, #{e.end_at.day}-#{et.month}-#{et.year}")
        else
          nst = DateTime.parse("#{e.start_at.hour}:#{e.start_at.min}:#{e.start_at.sec}, #{st.day}-#{st.month}-#{st.year}")  
          net = DateTime.parse("#{e.end_at.hour}:#{e.end_at.min}:#{e.end_at.sec}, #{et.day}-#{et.month}-#{et.year}")
        end
        #puts "#{nst}           :::::::::          #{net}"
      rescue
        nst = net = nil
      end
      if nst and net
        # e.attributes = event
        e.start_at, e.end_at = nst, net
        e.save
      end
    end

    event_series.attributes = event
    event_series.save
  end
end
