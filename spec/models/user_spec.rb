require 'rails_helper'
require "cancan/matchers"

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

  subject { FactoryGirl.create(:cites_ma_user) }

  describe "abilities" do
    subject(:ability){ Ability.new(user) }
    let(:user){ nil }

    context "when is system manager" do
      let(:user){ FactoryGirl.create(:system_managers_user) }
      it{ is_expected.to be_able_to(:manage, :all) }
    end

    context "when is cites ma" do
      let(:user){ FactoryGirl.create(:cites_ma_user) }
      it { is_expected.to be_able_to(:update, Organisation, id: user.organisation.id) }
      it { is_expected.to be_able_to(:update, Adapter, id: user.organisation.adapter.id) }
      it { is_expected.to be_able_to(:manage, User, organisation_id: user.organisation_id) }
    end

    context "when is customs ea" do
      let(:user){ FactoryGirl.create(:customs_ea_user) }
      it { is_expected.to be_able_to(:update, Organisation, id: user.organisation.id) }
      it { is_expected.to be_able_to(:manage, User, organisation_id: user.organisation_id) }
    end

    context "when is other" do
      let(:user){ FactoryGirl.create(:other_user) }
      it {
        is_expected.not_to be_able_to(
          :update, :create, :destroy,
          Organisation, id: user.organisation.id
        )
      }
      it {
        is_expected.not_to be_able_to(
          :update, :create, :destroy,
          Adapter, id: user.organisation.adapter.id
        )
      }
      it {
        is_expected.not_to be_able_to(
          :update, :create, :destroy,
          User, organisation_id: user.organisation_id
        )
      }
      it { is_expected.to be_able_to(:update, User, id: user.id) }
    end

    context "when is not admin" do
      let(:user) { FactoryGirl.create(:user) }
      it { is_expected.to be_able_to(:update, User, id: user.id) }
    end
  end
end
