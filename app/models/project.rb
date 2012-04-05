# == Schema Information
#
# Table name: projects
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  owner_id   :integer(4)
#  name       :string(255)
#  summary    :string(255)
#  tags       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Project < ActiveRecord::Base
  attr_accessible :name, :owner_id, :summary, :tags, :user_id
end
