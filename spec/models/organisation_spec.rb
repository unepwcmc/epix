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

  describe :display_name do
    let(:switzerland){
      FactoryGirl.create(:country, name: 'Switzerland')
    }
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
