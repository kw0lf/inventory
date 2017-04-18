require 'rails_helper'

RSpec.describe Brand, type: :model do
  describe "#provides category wise item count" do
    let!(:category) { create(:category) }
    let!(:brand) { create(:brand) }
    let!(:item) { create(:item, category: category1, brand: brand1) }

    context "the number of item's for different brand categorie's"
      it "should return one item for a category of brand " do
        expect(brand1.category_wise_items_count).to eq("#{category1.name}-1")
      end

    context "no item's for different brand categorie's"
      it "should not return anything" do
        expect(brand1.category_wise_items_count).to be_nil
    end
  end
end
