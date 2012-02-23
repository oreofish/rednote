# == Schema Information
#
# Table name: tasks
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  parent_id  :integer(4)
#  content    :string(255)
#  estimate   :integer(4)
#  deadline   :datetime
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe Task do
  pending "add some examples to (or delete) #{__FILE__}"
end
