require 'rails_helper'

describe FoodsController do
  let!(:food) { FactoryGirl.create :food }

  describe 'FoodsController#index' do
    it 'returns a 200 status code when accessing the index' do
      get :index
      expect(response.status).to be(200)
    end

    it 'renders a json object containing all food items' do
      get :index
      expect(response.body).to include(food.to_json)
    end
  end

  describe 'FoodsController#show' do
    it 'returns a 200 status code when showing an item' do
      get :show, params: {id: food.id}
      expect(response.status).to be(200)
    end

    it 'returns a json object containing the matching food item' do
      get :show, params: {id: food.id}
      expect(response.body).to eq(food.to_json)
    end

    it 'returns a 404 when the id is not present' do
      get :show, params: {id: 48981471}
      expect(response.status).to be(404)
    end
  end

  context 'with an unauthorized user' do
    let(:user) { FactoryGirl.create :user }
    before (:each) do
      session[:user_id] = user.id.to_s
    end

    it "returns a 403 when trying to create new food" do
      get :create, params: { name: "carrot", unit: "hectacre" }
      expect(response.status).to be(403)
    end

    it "returns a 403 when trying to destroy food" do
      get :destroy, params: {id: food.id}
      expect(response.status).to be(403)
    end
  end

  context 'with an admin user' do
    let(:admin) { FactoryGirl.create :admin }
    before (:each) do
      session[:user_id] = admin.id.to_s
    end

    describe 'FoodsController#create' do
      let(:params) {{
        name: "carrot",
        unit: "hectacre",
      }}

      it 'returns a 201 after creating a new item' do
        get :create, params: params
        expect(response.status).to be(201)
      end

      it 'creates a new item in the database on success' do
        expect { get :create, params: params }.to change { Food.all.length }.by(1)
      end

      it 'returns the id on success' do
        get :create, params: params
        food = JSON.parse(response.body)
        expect(Food.find_by(food[:id])).not_to be_nil
      end

      it 'returns a 400 if the name is missing' do
        get :create, params: { unit: 'miles' }
        expect(response.status).to be(400)
      end
    end

    describe 'FoodsController#destroy' do
      it 'returns a 200 after destroying the food item' do
        get :destroy, params: { id: food.id }
        expect(response.status).to be(200)
      end

      it 'successfully destroys the food item' do
        id = food.id
        get :destroy, params: { id: id }
        expect(Food.find_by(id: id)).to be_nil
      end

      it 'returns a 404 if the id is incorrect' do
        get :destroy, params: { id: 48924714 }
        expect(response.status).to be(404)
      end
    end
  end
end
