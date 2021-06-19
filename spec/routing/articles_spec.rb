require 'rails_helper'

RSpec.describe "/articles route" do
  it "routes to articles#index" do
    expect(get '/articles').to route_to('articles#index')
    expect(get '/articles?page[number]=3').to route_to('articles#index', "page" => { 'number' => '3' })
  end
end