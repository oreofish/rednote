# == Schema Information
#
# Table name: questions
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  content    :string(255)
#  attachment :string(255)
#  done       :boolean(1)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe Question do
  pending "add some examples to (or delete) #{__FILE__}"
end
