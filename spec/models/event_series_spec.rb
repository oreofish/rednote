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

require 'spec_helper'

describe EventSeries do
  pending "add some examples to (or delete) #{__FILE__}"
end
