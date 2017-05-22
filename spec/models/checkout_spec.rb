require 'rails_helper'

describe Checkout do
  describe "#checkin?" do
    let!(:employee)        { create(:employee) }
    let!(:item)            {  create(:item, employee: employee) }
    let!(:checkout)        { create(:checkout, item: item) }
    let!(:anothercheckout) {  create(:checkout, item: item, check_in: nil) }

    context "when check_in is present" do
      it "should return true" do
        expect(checkout.checkin?).to be true
      end
    end

    context "when check_in not present" do
      it "should return false" do
        expect(anothercheckout.checkin?).to be false
      end
    end
  end
end

describe Checkout do
  describe "#checkout_limitation" do
    context "when checkout date before purchase date" do
      let!(:item)     { create(:item, purchase_on: (Date.today)) }
      let!(:checkout) { build(:checkout, item: item, checkout: (Date.today-1)) }
      it "should be invalid" do
        expect(checkout).to be_invalid
      end
    end

    context "when check_in not present" do
      let!(:anotheritem)     { create(:item, purchase_on: (Date.today-1)) }
      let!(:anothercheckout) { create(:checkout, item: anotheritem, checkout: (Date.today)) }
      it "should be valid " do
        expect(anothercheckout).to be_valid
      end
    end
  end
end
