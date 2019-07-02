require 'rails_helper'

Rspec.describe Api::V1::ApplicationController, type: :controller do
  describe 'Includes the correct concers' do
	   it { expect(controller.class.ancestor).to include(Authenticable)}	
	end
end