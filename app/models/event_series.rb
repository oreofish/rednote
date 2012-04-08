# == Schema Information
#
# Table name: event_series
#
#  id         :integer(4)      not null, primary key
#  frequency  :integer(4)      default(1)
#  period     :string(255)     default("monthly")
#  start_at   :datetime
#  end_at     :datetime
#  all_day    :boolean(1)      default(FALSE)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  project_id :integer(4)
#  user_id    :integer(4)
#

class EventSeries < ActiveRecord::Base
  attr_accessor :title, :description, :commit_button
  has_many :events, :dependent => :destroy
  belongs_to :user

  validates  :frequency, :presence => true
  validates  :period, :presence => true
  validates  :start_at, :presence => true
  validates  :end_at, :presence => true
  validates  :title, :presence => true

  def after_create
    create_events_until(END_TIME)
  end

  def create_events_until(end_time)
    st = start_at
    et = end_at
    p = r_period(period)
    nst, net = st, et
    
    while frequency.send(p).from_now(st) <= end_time
      puts "#{nst}           :::::::::          #{net}" if nst and net
      self.events.create(:title => title, :description => description, :all_day => all_day, :start_at => nst, :end_at => net)
      nst = st = frequency.send(p).from_now(st)
      net = et = frequency.send(p).from_now(et)

      if period.downcase == 'monthly' or period.downcase == 'yearly'
        begin
          nst = DateTime.parse("#{start_at.hour}:#{start_at.min}:#{start_at.sec}, #{start_at.day}-#{st.month}-#{st.year}")  
          net = DateTime.parse("#{end_at.hour}:#{end_at.min}:#{end_at.sec}, #{end_at.day}-#{et.month}-#{et.year}")
        rescue
          nst = net = nil
        end
      end
    end
  end

  def r_period(period)
    case period
      when 'Daily'
      p = 'days'
      when "Weekly"
      p = 'weeks'
      when "Monthly"
      p = 'months'
      when "Yearly"
      p = 'years'
    end
    return p
  end
  
end
