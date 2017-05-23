require 'rails_helper'

describe User  do
  describe "#give's full name of user" do
    let!(:user) { create(:user) }
    context "when full name is created" do
      it "should give the full name" do
        expect(user.full_name).to eq("#{user.first_name} #{user.last_name}")
      end
    end
  end
end
