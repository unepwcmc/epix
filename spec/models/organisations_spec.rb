require "rails_helper"

RSpec.describe Organisation, type: :model do
  it "has a valid role" do
    expect(FactoryGirl.build(:organisation)).to be_valid
  end

  it "has an invalid role" do
    organisation = FactoryGirl.build(:organisation, role: 'role')
    expect(organisation).to be_invalid
  end

  it "has an invalid name" do
    FactoryGirl.create(:organisation, name: 'org')
    expect(FactoryGirl.build(:organisation, name: 'org')).to be_invalid
  end

  it "is invalid without name" do
    expect(FactoryGirl.build(:organisation, name: '')).to be_invalid
  end

  it "is invalid without role" do
    expect(FactoryGirl.build(:organisation, role: '')).to be_invalid
  end

  it "is invalid without country" do
    expect(FactoryGirl.build(:organisation, country: nil)).to be_invalid
  end
end
