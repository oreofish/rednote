# == Schema Information
#
# Table name: notes
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  content    :text
#  image      :string(255)
#  link       :string(255)
#  type       :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Note do
  pending "add some examples to (or delete) #{__FILE__}"
end
