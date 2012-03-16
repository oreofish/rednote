# == Schema Information
#
# Table name: answers
#
#  id          :integer(4)      not null, primary key
#  user_id     :integer(4)
#  question_id :integer(4)
#  score       :integer(4)
#  content     :text
#  attachment  :string(255)
#  done        :boolean(1)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

class Answer < ActiveRecord::Base
end
