# == Schema Information
#
# Table name: answers
#
#  id          :integer(4)      not null, primary key
#  user_id     :integer(4)
#  question_id :integer(4)
#  score       :integer(4)
#  content     :text
#  done        :boolean(1)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

require 'spec_helper'

describe Answer do
  pending "add some examples to (or delete) #{__FILE__}"
end
