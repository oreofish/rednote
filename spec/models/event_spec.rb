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

require 'spec_helper'

describe Event do
  pending "add some examples to (or delete) #{__FILE__}"
end
