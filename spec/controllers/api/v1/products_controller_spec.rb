require 'rails_helper'

describe Api::V1::ProductsController do
  let(:user) { FactoryGirl.create(:user) }

  describe "GET #show" do
    before(:each) do
      @product = FactoryGirl.create(:product)
      sign_in_user user
      get :show, params: {id: @product.id}
    end

    it "returns the information about a reporter on a hash" do
      product_response = json_response
      expect(product_response[:title]).to eql @product.title
    end

    it { should respond_with 200}
  end

  describe "GET #index" do
    before(:each) do
      4.times {FactoryGirl.create :product}
      sign_in_user user
      get :index
    end

    it "returns all records from the database" do
      products_response = json_response
      expect(products_response).not_to be_empty
    end

    it {should respond_with 200}
  end

  describe "POST #create" do
    context "when is successfully created" do
      before(:each) do
        @product_attributes = FactoryGirl.attributes_for :product
        sign_in_user user
        post :create, params: {user_id: user.id, product: @product_attributes}
      end

      it "renders the json representation for the product record just created" do
        expect(json_response[:title]).to eql @product_attributes[:title]
      end

      it {should respond_with 201}
    end
  end

end
