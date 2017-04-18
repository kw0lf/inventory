require 'rails_helper'

RSpec.describe Brand, type: :model do
  describe "#provides category wise item count" do
    let!(:category1) { create(:category) }
    let!(:category2) { create(:category) }
    let!(:brand1) { create(:brand) }
    let!(:brand2) { create(:brand) }
    let!(:item1) { create(:item, category: category1, brand: brand1) }
    let!(:item2) { create(:item, category: category2, brand: brand2) }

    context "provides the number of item's within a particular brand"
      it "provides one count of category" do
        expect(brand1.category_wise_items_count).to eq("#{category1.name}-1")
      end

    context "do not provide the number of item's within a particular brand"
      it "do not provide count of category" do
        expect(brand1.category_wise_items_count).to be_nil
    end
  end
end
