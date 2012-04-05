# == Schema Information
#
# Table name: infos
#
#  id           :integer(4)      not null, primary key
#  user_id      :integer(4)
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#  message_id   :integer(4)
#  message_type :string(255)
#  read         :integer(4)      default(1)
#  refer        :integer(4)      default(0)
#

class Info < ActiveRecord::Base
  belongs_to :user

  belongs_to :message, :polymorphic => true

  validates :user_id,           :presence => true
  validates :message_id,        :presence => true
end
