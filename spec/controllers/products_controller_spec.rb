require 'rails_helper'

describe ProductsController do
  let!(:product) { FactoryGirl.create(:product) }
  describe '#index' do
    it 'responds with a json blob containing a product from the database' do
      get :index
      expect(response.body).to include(product.name)
    end
  end
  describe '#show' do
    it 'responds with a json blob containing a single product' do
      get :show, params: {id: product.id}
      expect(response.body).to include(product.name)
    end
  end
end
