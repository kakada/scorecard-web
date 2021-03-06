# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default("")
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
#  language_code          :string           default("en")
#  unlock_token           :string
#  locked_at              :datetime
#  failed_attempts        :integer          default(0)
#  local_ngo_id           :integer
#
class User < ApplicationRecord
  include Confirmable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, :lockable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:google_oauth2]

  enum role: {
    system_admin: 1,
    program_admin: 2,
    staff: 3,
    lngo: 4
  }

  ROLES = [
    ["System Admin", "system_admin"],
    ["Admin", "program_admin"],
    ["Staff/Officer", "staff"],
    ["Lngo", "lngo"]
  ]

  # Association
  belongs_to :program, optional: true
  belongs_to :local_ngo, optional: true

  # Validation
  validates :role, presence: true
  validates :program_id, presence: true, unless: -> { system_admin? }
  validates :local_ngo_id, presence: true, if: -> { lngo? }

  # Callback
  before_create :generate_authentication_token

  # Delegation
  delegate :name, to: :program, prefix: :program, allow_nil: true
  delegate :name, to: :local_ngo, prefix: :local_ngo, allow_nil: true

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

  def display_name
    email.split("@").first.upcase
  end

  def status
    return "locked" if access_locked?
    return "actived" if confirmed?

    "pending"
  end

  private
    def generate_authentication_token
      self.encrypted_password ||= ""
      self.authentication_token = Devise.friendly_token
      self.token_expired_date = (ENV.fetch("TOKEN_EXPIRED_IN_DAY") { 1 }).to_i.day.from_now
    end
end
