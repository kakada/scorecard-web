# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  role                   :integer
#  program_id             :integer
#  authentication_token   :string           default("")
#  token_expired_date     :datetime
#
class User < ApplicationRecord
  include Confirmable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:google_oauth2]

  enum role: {
    system_admin: 1,
    program_admin: 2,
    staff: 3,
    guest: 4
  }

  ROLES = roles.keys.map { |r| [r.titlecase, r] }

  # Association
  belongs_to :program, optional: true

  # Validation
  validates :role, presence: true
  validates :program_id, presence: true, unless: -> { role == "system_admin" }

  # Callback
  before_create :generate_authentication_token

  # Delegation
  delegate :name, to: :program, prefix: :program, allow_nil: true

  # Class methods
  def self.filter(params)
    scope = all
    scope = scope.where("email LIKE ?", "%#{params[:email]}%") if params[:email].present?
    scope
  end

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data["email"]).first
    user
  end

  def self.from_authentication_token(token)
    self.where(authentication_token: token).where("token_expired_date >= ?", Time.zone.now).first
  end

  # Instant methods
  def regenerate_authentication_token!
    generate_authentication_token
    self.save
  end

  private
    def generate_authentication_token
      self.authentication_token = Devise.friendly_token
      self.token_expired_date = (ENV.fetch("TOKEN_EXPIRED_IN_DAY") { 1 }).to_i.day.from_now
    end
end
