require 'rails_helper'

describe Brand do
  describe "#provides category wise item count" do
    let!(:category)     { create(:category) }
    let!(:brand)        { create(:brand) }
    let!(:anotherbrand) { create(:brand) }
    let!(:item)         { create(:item, category: category, brand: brand) }

    context "when item present" do
      it "should return category name with one item" do
        expect(brand.category_wise_items_count).to eq("#{category.name}-1")
      end
    end

    context "when item not present" do
      it "should return blank string" do
        expect(anotherbrand.category_wise_items_count).to be_empty
      end
    end
  end
end
