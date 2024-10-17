class User < ApplicationRecord
  has_secure_password

  generates_token_for :email_verification, expires_in: 2.days do
    email
  end
  generates_token_for :password_reset, expires_in: 20.minutes do
    password_salt.last(10)
  end

  has_many :members, dependent: :destroy
  has_many :clubs, through: :members
  has_many :issues, through: :clubs
  has_many :answers, through: :members
  has_many :sessions, dependent: :destroy
  has_many :events, dependent: :destroy

  before_validation :generate_username
  before_save :downcase_email
  before_save :downcase_username

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, allow_nil: true, length: { minimum: 6 }
  validates :timezone, inclusion: { in: ActiveSupport::TimeZone.all.map(&:name) }, allow_blank: true

  before_create :set_default_timezone

  normalizes :email, with: -> { _1.strip.downcase }

  before_validation if: :email_changed?, on: :update do
    self.verified = false
  end

  after_update if: :password_digest_previously_changed? do
    sessions.where.not(id: Current.session).delete_all
  end

  after_update if: :email_previously_changed? do
    events.create! action: "email_verification_requested"
  end

  after_update if: :password_digest_previously_changed? do
    events.create! action: "password_changed"
  end

  after_update if: [ :verified_previously_changed?, :verified? ] do
    events.create! action: "email_verified"
  end

  def membership(club)
    members.find_by(club: club)
  end

  def member_of?(club)
    members.active.exists?(club: club)
  end

  def owner_of?(club)
    members.exists?(club: club, role: :owner)
  end

  def admin_of?(club)
    members.exists?(club: club, role: :admin)
  end

  def can_manage?(club)
    owner_of?(club) || admin_of?(club)
  end

  def self.find_unique_username(username)
    taken_usernames = User
                        .where("username LIKE ?", "#{username}%")
                        .pluck(:username)

    # username if it's free
    return username if ! taken_usernames.include?(username)

    count = 2
    while true
      # username_2, username_3...
      new_username = "#{username}_#{count}"
      return new_username if ! taken_usernames.include?(new_username)
      count += 1
    end
  end

  def self.generate_username(fullname)
    ActiveSupport::Inflector.transliterate(fullname) # change ñ => n
                            .split("@")
                            .first
                            .downcase              # only lower case
                            .strip                 # remove spaces around the string
                            .gsub(/[^a-z]/, "_")   # any character that is not a letter or a number will be _
                            .gsub(/\A_+/, "")      # remove underscores at the beginning
                            .gsub(/_+\Z/, "")      # remove underscores at the end
                            .gsub(/_+/, "_")       # maximum an underscore in a row
  end

  def self.create_user(params)
    username = generate_username(params.fetch(:name))
    username = find_unique_username(username)
    user = User.create(params.merge(username: username))
    if user.errors.details[:username].any? { |h| h[:error] == :taken }
      # a faster thread took our username, try again!
      create_user(params)
    else
      user
    end
  end

  def super_admin?
    email == "yosefserkez@gmail.com"
  end

  private

  def downcase_email
    self.email = email.downcase
  end

  def downcase_username
    self.username = username.downcase
  end

  def generate_username
    name ||= email
    self.username = User.find_unique_username(User.generate_username(name))
  end

  def set_default_timezone
    self.timezone ||= Time.zone.name
  end
end
