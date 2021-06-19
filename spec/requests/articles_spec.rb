require 'rails_helper'

RSpec.describe ArticlesController do
  describe "#index" do
    it "returns a success response" do
      get '/articles'
      # expect(response.status).to eq(200)
      expect(response).to have_http_status(:ok)
    end

    it "returns a proper JSON" do
      article = create :article
      get '/articles'
      # json_data comes from support/api_helpers
      # to use it we enabled
      # `Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }` this on rails_helper.rb
      # and also we wrote down `config.include ApiHelpers` to not write require 'api_helpers' in every test file.
      expect(json_data.length).to eq(1)
      expected_data = json_data.first

      aggregate_failures do
        expect(expected_data[:id]).to eq(article.id.to_s)
        expect(expected_data[:attributes][:title]).to eq(article.title)
        expect(json_data).to eq([
                                  {
                                    id: article.id.to_s,
                                    type: 'article',
                                    attributes: {
                                      title: article.title,
                                      content: article.content,
                                      slug: article.slug
                                    }
                                  }
                                ])
      end
    end
  end
end