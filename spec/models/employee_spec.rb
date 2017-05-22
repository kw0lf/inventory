require 'rails_helper'

describe Employee do
  describe "#deallocate item's when active changed" do
    let!(:employee)        { create(:employee, active: false) }
    let!(:anotheremployee) { create(:employee, active: true) }
    let!(:item)            { create(:item, employee: employee) }
    let!(:anotheritem)     { create(:item, employee: anotheremployee) }

    context "when active is false" do
      it "should clear item" do
        expect(employee.items).to eq([])
      end
    end

    context "when active is true" do
      it "should not empty item" do
        expect(anotheremployee.items).to eq([anotheritem])
      end
    end
  end
end
