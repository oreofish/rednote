# == Schema Information
#
# Table name: notes
#
#  id          :integer(4)      not null, primary key
#  user_id     :integer(4)
#  content     :text
#  image       :string(255)
#  link        :string(255)
#  kind        :integer(4)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  book        :string(255)
#  description :text
#

require 'spec_helper'

describe Note do
  pending "add some examples to (or delete) #{__FILE__}"
end
