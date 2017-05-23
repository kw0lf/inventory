require 'rails_helper'

describe Item do
  describe "#edit_item_details" do
    let!(:category)         { create(:category) }
    let!(:brand)            { create(:brand) }
    let!(:another_category) { create(:category) }
    let!(:another_brand)    { create(:brand) }
    let!(:item)             { create(:item, category: category, brand: brand, created_at: 6.day.ago.to_datetime) }

    context "when category is changed" do
      it "should be invalid" do
        item.update(category: another_category)
        expect(item).to be_invalid
      end
    end

    context "when brand is changed" do
      it "should be invalid" do
        item.update(brand: another_brand)
        expect(item).to be_invalid
      end
    end
  end

  describe ".unassociated_items" do
    let!(:item)               { create(:item) }
    let!(:child_item)         { create(:item, parent: item) }
    let!(:unassociated_item1) { create(:item) }
    let!(:unassociated_item2) { create(:item) }

    context "when parent is present" do
      it "should return item's which have no parent" do
        expect(Item.unassociated_items(item)).to include(unassociated_item1, unassociated_item2)
      end
    end
  end

  describe ".filter_by_status" do
    let!(:employee)         { create(:employee) }
    let!(:allocated_item)   { create(:item, employee: employee) }
    let!(:discarded_item)   { create(:item, discarded_at: Date.today) }
    let!(:unallocated_item) { create(:item) }

    context "when employee_id is nil" do
      it "should return unallocated item's" do
        expect(Item.filter_by_status("Unallocated")).to eq([discarded_item, unallocated_item])
      end
    end

    context "when discarded_at is not nil" do
      it "should return discarded item's" do
        expect(Item.filter_by_status("Discarded")).to eq([discarded_item])
      end
    end

    context "when employee_id is present" do
      it "should return allocated item's" do
        expect(Item.filter_by_status("Allocated")).to eq([allocated_item])
      end
    end
  end

  describe "#change_parent" do
    let!(:item)         { create(:item) }
    let!(:item1)        { create(:item) }
    let!(:another_item) { create(:item, parent: item) }

    context "when parent is changed" do
      it "should change the parent" do
        expect(another_item.change_parent(item1)).to be true
      end
    end
  end

  describe "#add_child" do
    let!(:item)         { create(:item) }
    let!(:another_item) { create(:item, parent: item) }
    let!(:child_item)   { create(:item) }

    context "when child is added" do
      it "should change the child" do
        expect(item.add_child(child_item)).to be true
      end
    end
  end

  describe "#name" do
    let!(:brand)        { create(:brand, name: "HP") }
    let!(:category)     { create(:category, name: "Monitor") }
    let!(:item)         { create(:item, brand: brand, category: category) }
    let!(:another_item) { create(:item, brand: nil, category: category) }

    context "when brand is present" do
      it "should give the name of brand and category for item" do
        expect(item.name).to eq("HP Monitor")
      end
    end

    context "when brand is not present" do
      it "should give only category for item" do
        expect(another_item.name).to eq(" Monitor")
      end
    end
  end

  describe "#name_with_id" do
    let!(:brand)    { create(:brand, name: "HP") }
    let!(:category) { create(:category, name: "Monitor") }
    let!(:item)     { create(:item, brand: brand, category: category) }

    context "when item is present" do
      it "should give the item name with ID" do
        expect(item.name_with_id).to eq("HP Monitor (#{item.id})")
      end
    end
  end

  describe "#pending_checkout" do
    let!(:item)             { create(:item) }
    let!(:employee)         { create(:employee) }
    let!(:another_employee) { create(:employee) }
    let!(:checkout)         { create(:checkout, employee: employee, check_in: nil, reason: "System failure", checkout: Date.today, item: item, created_at: Date.today) }
    let!(:another_checkout) { create(:checkout, employee: another_employee, check_in: nil, reason: "any reason", checkout: Date.today, item: item, created_at: Date.today-1) }

    context "when check_in is nil" do
      it "should return all checkout's whose check_in is nil" do
        expect(item.pending_checkout).to eq(checkout)
      end
    end
  end

  describe "#reallocate" do
    let!(:employee)         { create(:employee) }
    let!(:item)             { create(:item, employee: employee) }
    let!(:another_employee) { create(:employee) }

    context "when employee is reallocated" do
      it "should return true" do
        expect(item.reallocate(employee)).to be true
      end
    end
  end

  describe "#unavailable?" do
    let!(:item)             { create(:item) }
    let!(:another_item)     { create(:item) }
    let!(:checkout)         { create(:checkout, item: item, check_in: Date.today, reason: "anything", checkout: Date.today) }
    let!(:another_checkout) { create(:checkout, item: another_item, check_in: nil, reason: "anything", checkout: Date.today) }

    context "when checkin is present" do
      it "should return false" do
        expect(item.unavailable?).to be false
      end
    end

    context "when checkin is not present" do
      it "should return true" do
        expect(another_item.unavailable?).to be true
      end
    end
  end

  describe "#discard" do
    let!(:item) { create(:item) }

    context "when item is discarded" do
      it "should return true" do
        expect(item.discard("system failure")).to be true
      end
    end
  end

  describe "#update_item_history" do
    let!(:employee)         { create(:employee) }
    let!(:another_employee) { create(:employee) }
    let!(:item)             { create(:item, employee: employee, parent: another_item) }
    let!(:another_item)     { create(:item) }
    let!(:parent_item)            { create(:item) }

    context "when employee ID is changed" do
      it "should update_item_history" do
        item.update(employee: another_employee)
        expect(item.item_histories.size).to eq(2)
      end
    end

    context "when working status is changed" do
      it "should update item_history" do
        item.update(working: false)
        expect(item.item_histories.size).to eq(2)
      end
    end

    context "when parent is changed" do
      it "should update item_history" do
        another_item.update(parent: parent_item)
        expect(another_item.item_histories.size).to eq(2)
      end
    end
  end
end
