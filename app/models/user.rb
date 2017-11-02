class User < ApplicationRecord
  has_many :articles, -> { order('created_at DESC, title ASC') }, :dependent => :nullify

  enum role: [:user, :vip, :admin]
  after_initialize :set_default_role, :if => :new_record?

  def set_default_role
    self.role ||= :user
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_confirmation_of :password
  validates_length_of :password, :within => 4..20
  validates_presence_of :password, :if => :password_required?

  def password_required?
    encrypted_password.blank? || password.present?
  end

  def username
    n = email.split('@')[0].split('.')
    "#{n[0].capitalize} #{n[1].capitalize}"
  end
end
