require 'rails_helper'

class Authentication < ActionController::Base
  include Api::V1::Concerns::Authenticator
end

describe Api::V1::Concerns::Authenticator do
  let(:user) { FactoryGirl.create(:user) }
  let(:authentication) { Authentication.new }
  subject { authentication }
end
