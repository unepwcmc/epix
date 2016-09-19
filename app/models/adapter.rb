class Adapter < ApplicationRecord
  attr_encrypted :auth_token, key: Rails.application.secrets.adapter["auth_token_key"]
  attr_encrypted :auth_username, key: Rails.application.secrets.adapter["auth_username_key"]
  attr_encrypted :auth_password, key: Rails.application.secrets.adapter["auth_password_key"]

  belongs_to :organisation

  def cites_toolkit_v2?
    cites_toolkit_version == 2
  end
end
