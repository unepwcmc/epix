require 'rails_helper'

RSpec.describe User, type: :model do
  it "has an invalid email" do
    user = FactoryGirl.build(:user, email: 'joe.doe.email')
    expect(user).to be_invalid
  end

  it "is invalid without first name" do
    expect(FactoryGirl.build(:user, first_name: nil)).to be_invalid
  end

  it "is invalid without last name" do
    expect(FactoryGirl.build(:user, last_name: nil)).to be_invalid
  end

  it "is invalid without email" do
    expect(FactoryGirl.build(:user, email: nil)).to be_invalid
  end

  subject { FactoryGirl.create(:user) }

  it 'sends an email' do
    expect { subject.send_welcome_email }
      .to change { ActionMailer::Base.deliveries.count }.by(1)
  end
end
