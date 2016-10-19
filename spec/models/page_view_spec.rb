require "rails_helper"

RSpec.describe PageView, :type => :model do
  describe "when it is initialized" do
    context "and it has an id present" do
      it "creates a hash of data attributes and stores that in the hash field" do
        seedset = PageViewSeedSet.new
        random_attributes = seedset.random_attributes
        new_page_view = PageView.new(random_attributes)
        expect(new_page_view[:id].present?).to be(true)
        expect(new_page_view[:hash]).to eq(new_page_view.send(:md5_hash))
      end
    end
  end
end
