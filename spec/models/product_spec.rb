require 'rails_helper'

describe Product do
  let(:product) {FactoryGirl.build :product}
  subject { product }

  it { should respond_to{:title}}
  it { should respond_to{:price}}
  it { should respond_to{:published}}
  it { should respond_to{:user_id}}


  it {should validate_presence_of :title}
  it { should validate_presence_of :price}
  it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0)}
  it { should validate_presence_of :user_id}

  it {should belong_to :user}

  describe ".filter_by_title" do
    before(:each) do
      @product1 = FactoryGirl.create :product, title: "A plasma TV"
      @product2 = FactoryGirl.create :product, title: "Fastest laptop"
      @product3 = FactoryGirl.create :product, title: "CD player"
      @product4 = FactoryGirl.create :product, title: "LCD TV"
    end

    context "when a 'TV' title pattern is sent" do
      it "returns the 2 products matching" do
        expect(Product.filter_by_title('TV')).not_to be_empty
      end

      it "returns the products matching" do
        expect(Product.filter_by_title("TV").sort).to match_array([@product1, @product4])
      end

    end
  end

  describe ".above_or_equal_to_price" do

    before(:each) do
      @product1 = FactoryGirl.create :product, price: 100
      @product2 = FactoryGirl.create :product, price: 200
      @product3 = FactoryGirl.create :product, price: 50
      @product4 = FactoryGirl.create :product, price: 75
    end

    it "returns the products witch are above or equal to the price" do
      expect(Product.above_or_equal_to_price(100).sort).to match_array([@product1, @product2])
    end

  end

  describe ".bellow_or_equal_to_price" do

    before(:each) do
      @product1 = FactoryGirl.create :product, price: 100
      @product2 = FactoryGirl.create :product, price: 200
      @product3 = FactoryGirl.create :product, price: 50
      @product4 = FactoryGirl.create :product, price: 75
    end

    it "returns the products witch are bellow or equal to price" do
      expect(Product.bellow_or_equal_to_price(75).sort).to match_array([@product3, @product4])
    end
  end

  describe ".recent" do

    before(:each) do
      @product1 = FactoryGirl.create :product, price: 100
      @product2 = FactoryGirl.create :product, price: 200
      @product3 = FactoryGirl.create :product, price: 50
      @product4 = FactoryGirl.create :product, price: 75

      @product1.touch
      @product2.touch
    end

    it "returns the most updated records" do
      expect(Product.recent).to match_array([@product2, @product1, @product3, @product4])
    end
  end

end
