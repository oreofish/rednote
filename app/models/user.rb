# == Schema Information
#
# Table name: users
#
#  id                     :integer(4)      not null, primary key
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(128)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer(4)      default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#  nickname               :string(255)
#  avatar                 :string(255)     default("/images/icons/00.jpeg")
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :nickname, :avatar, :avatar_cache

  has_many :notes, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :tasks, :dependent => :destroy
  has_many :likes, :dependent => :destroy

  mount_uploader :avatar, AvatarUploader

  attr_accessor :crop_x, :crop_y, :crop_h, :crop_w
  after_update :reprocess_avatar, :if => :cropping?

  def cropping?
      !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end

  def avatar_geometry
      img = Magick::Image::read(self.avatar.current_path).first
      @geometry = {:width => img.columns, :height => img.rows }
  end

  private

  def reprocess_avatar
      self.avatar.recreate_versions!
  end

end
