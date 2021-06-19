require 'rails_helper'

RSpec.describe Article, type: :model do

  describe "#validations" do
    # we can use create here but create would hit db so if it is not necessary don't use create
    let(:article) { build(:article) }

    it "tests that factory is valid" do
      expect(article).to be_valid
    end

    it "has an invalid title" do
      article.title = ""
      expect(article).not_to be_valid
      expect(article.errors[:title]).to include("can't be blank")
    end

  end

end
