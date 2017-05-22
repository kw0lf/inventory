require 'rails_helper'

describe User  do
  describe "#give's full name of user" do
    let!(:user) { create(:user, first_name: "John", last_name: "Doe") }
    context "when full name is created" do
      it "should give the full name" do
        expect(user.full_name).to eq("John Doe")
      end
    end
  end
end
