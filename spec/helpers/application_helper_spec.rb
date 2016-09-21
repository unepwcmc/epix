require "rails_helper"

describe ApplicationHelper do
  describe "date_format" do
    it "parses datetime string and returns date string" do
      expect(helper.date_format('2012-02-23T00:00:00.000+01:00')).to eql('23-02-2012')
    end

    it "returns argument if it is not a date" do
      expect(helper.date_format('last week')).to eql('last week')
    end
  end
end
