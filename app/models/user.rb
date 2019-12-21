class User < ApplicationRecord
  after_create  :create_profile
  before_create :init_role

  before_update :check_cropping

  def check_cropping
    self.profile.crop_settings = {x: profile.crop_x, y: profile.crop_y, w: profile.crop_w, h: profile.crop_h} if self.profile.avatar.attached? && profile.cropping?
  end

  extend FriendlyId
  friendly_id :login, use: %i[slugged]

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable, :omniauthable

  has_one :profile
  has_many :articles
  has_many :videos

  validates :login,
      presence: true,
      uniqueness: true,
      exclusion: { in: LOGIN_BLACKLIST },
      length: { in: 3..12 },
      format: { with: /\A[A-Za-z0-9_]+\z/ }


  accepts_nested_attributes_for :profile

  ROLES = %w[admin user moderator guest]

  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.sum
  end

  def roles
    ROLES.reject { |r| ((roles_mask || 0) & 2**ROLES.index(r)).zero? }
  end

  def self.with_role(role)
    where('roles_mask & ? > 0', 2**ROLES.index(role.to_s))
  end

  def role?(role)
    roles.include? role.to_s
  end

  private

  def init_role
    self.roles_mask = 2
  end
end
