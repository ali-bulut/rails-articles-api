require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do
  describe "#index" do
    it "returns a success response" do
      get :index
      # expect(response.status).to eq(200)
      expect(response).to have_http_status(:ok)
    end

    it "returns a proper JSON" do
      article = create :article
      get :index
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

    it "returns articles in the proper order" do
      older_article = create(:article, created_at: 1.hour.ago, slug: "test")
      recent_article = create :article
      get :index
      ids = json_data.map { |item| item[:id].to_i }
      expect(ids).to eq([recent_article.id, older_article.id])
    end

    it "contains pagination links in the response" do
      article1, article2, article3 = create_list(:article, 3)
      get :index, params: { page: { number: 2, size: 1 } }
      expect(json[:links].length).to eq(5)
      expect(json[:links].keys).to contain_exactly(:first, :prev, :next, :last, :self)
    end

    it "paginates result" do
      article1, article2, article3 = create_list(:article, 3)
      get :index, params: { page: { number: 2, size: 1 } }
      expect(json_data.length).to eq(1)
      expect(json_data.first[:id]).to eq(article2.id.to_s)
    end

  end

  describe "#create" do
    subject { post :create }
    context "when no code provided" do
      it_behaves_like "forbidden_requests"
    end

    context "when invalid code provided" do
      before { request.headers['authorization'] = 'invalid_token' }
      it_behaves_like "forbidden_requests"
    end

    context "when authorized" do
      let(:user) { create :user }
      let(:access_token) { user.create_access_token }
      before { request.headers['authorization'] = "Bearer #{access_token.token}" }

      context "when invalid parameters provided" do
        let(:invalid_attributes) do
          {
            data: {
              attributes: {
                title: '',
                content: ''
              }
            }
          }
        end
        subject { post :create, params: invalid_attributes }
        it 'should return 422 status code' do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

end