class User < ApplicationRecord
  has_many :items

  before_save { self.email = email.downcase }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 105 }, uniqueness: { case_sensitive: false },
 			      format: { with: VALID_EMAIL_REGEX }

  def full_name
    return "#{first_name} #{last_name}".strip if(first_name || last_name)
    "Anonymous"
  end

  def self.find_and_update_from_auth(auth)
    user ||= User.find_by_email(auth.info.email)

    if user
      user.first_name   = auth.info.first_name
      user.last_name    = auth.info.last_name
      user.google_uid   = auth.uid
      user.access_token = auth.credentials.token
      user.google_uid   = auth.uid
      user.save
    end

    user
  end
end
