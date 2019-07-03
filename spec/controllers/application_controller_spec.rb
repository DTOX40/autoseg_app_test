require 'rails_helper'

Rspec.describe ApplicationController, type: :controller do
  describe 'Includes the correct concers' do
	   it { expect(controller.class.ancestor).to include(Authenticable)}	
	end
end