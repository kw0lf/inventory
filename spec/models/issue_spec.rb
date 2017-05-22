require 'rails_helper'

describe Issue do
  describe "#item_closed_at_limitation" do
    let!(:item)          { create(:item, purchase_on: Date.today) }
    let!(:issue)         { build(:issue, item: item, closed_at: Date.today-1) }
    let!(:another_item)  { create(:item, purchase_on: Date.today-1) }
    let!(:another_issue) { build(:issue, item: another_item, closed_at: Date.today) }

    context "when closed_at date is greater than purchase_on date" do
      it "should be bot be valid" do
        expect(issue).to be_invalid
      end
    end

    context "when closed_at date is smaller than purchase_on date" do
      it "should  be valid" do
        expect(another_issue).to be_valid
      end
    end
  end
end
