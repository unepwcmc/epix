require "rails_helper"

RSpec.describe Organisation, type: :model do
  let(:switzerland){
    FactoryGirl.create(:country, name: 'Switzerland')
  }

  it "has a valid role" do
    expect(FactoryGirl.build(:cites_ma)).to be_valid
  end

  it "has an invalid role" do
    organisation = FactoryGirl.build(:organisation, role: 'role')
    expect(organisation).to be_invalid
  end

  it "is a duplicate (role within country)" do
    organisation_attributes = {
      country: switzerland,
      role: Organisation::CITES_MA
    }
    FactoryGirl.create(:organisation, organisation_attributes)
    expect(FactoryGirl.build(:organisation, organisation_attributes)).to be_invalid
  end

  it "is a duplicate (name within role & country)" do
    organisation_attributes = {
      name: 'Ministry of Environment',
      country: switzerland
    }
    FactoryGirl.create(:organisation, organisation_attributes)
    expect(FactoryGirl.build(:organisation, organisation_attributes)).to be_invalid
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

  describe :display_name do
    let(:swiss_ma){
      FactoryGirl.create(:organisation, role: Organisation::CITES_MA, country: switzerland)
    }
    specify{
      expect(swiss_ma.display_name).to eq('CITES MA of Switzerland')
    }
    let(:swiss_customs){
      FactoryGirl.create(:organisation, role: Organisation::CUSTOMS_EA, country: switzerland)
    }
    specify{
      expect(swiss_customs.display_name).to eq('Customs EA of Switzerland')
    }
    let(:unep_wcmc){
      FactoryGirl.create(:organisation, role: Organisation::SYSTEM_MANAGERS, name: 'UNEP-WCMC')
    }
    specify{
      expect(unep_wcmc.display_name).to eq('UNEP-WCMC')
    }
    let(:cites_secretariat){
      FactoryGirl.create(:organisation, role: Organisation::OTHER, name: 'CITES Secretariat')
    }
    specify{
      expect(cites_secretariat.display_name).to eq('CITES Secretariat')
    }
  end

end
