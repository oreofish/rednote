# == Schema Information
#
# Table name: ats
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  at_type    :string(255)
#  at_id      :integer(4)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class At < ActiveRecord::Base
end
