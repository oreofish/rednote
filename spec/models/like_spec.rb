# == Schema Information
#
# Table name: likes
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  note_id    :integer(4)
#  status     :boolean(1)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe Like do
  pending "add some examples to (or delete) #{__FILE__}"
end
