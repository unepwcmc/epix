require 'rails_helper'

RSpec.describe User, type: :model do
  subject { FactoryGirl.create(:user) }

  it 'sends an email' do
    expect { subject.send_welcome_email }
      .to change { ActionMailer::Base.deliveries.count }.by(1)
  end
end
