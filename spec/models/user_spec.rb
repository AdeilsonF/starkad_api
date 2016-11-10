require 'rails_helper'

describe User do
  before { @user = FactoryGirl.build(:user)}

  subject {@user}

  it { should respond_to(:email)}
  it { should respond_to(:password)}
  it { should respond_to(:password_confirmation)}
  it { should be_valid}
  it { should validate_confirmation_of(:password)}
  it { should validate_presence_of(:email)}

  it {should respond_to(:auth_token)}
  it {should validate_uniqueness_of(:auth_token)}

  it { should have_many(:products)}



  describe "when email is not present" do
    before {@user.email = ""}
    it {should_not be_valid}

  end

  describe "#generate_authentication_token!" do
    it "generates a unique token" do
      allow(Devise).to receive(:friendly_token).and_return('uniquetoken')
      user = FactoryGirl.create(:user)
      expect(user.auth_token).to eq('uniquetoken')
    end

    it "generates another token when one already has been taken" do
      allow(Devise).to receive(:friendly_token).and_return('uniquetoken',
                                                          'uniquetoken',
                                                          'newuniquetoken')
      existing_user = FactoryGirl.create(:user)
      new_user = FactoryGirl.create(:user)
      expect(existing_user.auth_token).to eql 'uniquetoken'
      expect(new_user.auth_token).to eql 'newuniquetoken'
      expect(existing_user.auth_token).not_to eql new_user.auth_token
    end
  end

  describe "#products association" do
    before do
      @user.save
      3.times {FactoryGirl.create :product, user: @user}
    end

    it "destroys the associated products on self destruct" do
      products = @user.products
      @user.destroy
      products.each do |product|
        expect(Product.find(product)).to raise_error ActiveRecord::RecordNotFound
      end
    end
  end


end


