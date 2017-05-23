require 'rails_helper'

describe Employee do
  describe "#deallocate item's when active changed" do
    let!(:employee)         { create(:employee, active: false) }
    let!(:another_employee) { create(:employee, active: true) }
    let!(:item)             { create(:item, employee: employee) }
    let!(:another_item)     { create(:item, employee: another_employee) }

    context "when active is false" do
      it "should clear item" do
        expect(employee.items).to eq([])
      end
    end

    context "when active is true" do
      it "should not empty item" do
        expect(another_employee.items).to eq([another_item])
      end
    end
  end
end
