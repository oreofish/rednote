class Message < ActiveRecord::Base
  belongs_to :user

  belongs_to :message, :polymorphic => true

  validates :user_id,           :presence => true
  validates :message_id,        :presence => true
end
