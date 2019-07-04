require 'rails_helper'
require 'database_cleaner'

Respec.describe Authenticable do
	controller(AplicationController) do
		include Authenticable
	end	

	let(:app_controller) { subject }


	describe '#current_user' do
		let(:user) { create(:user) }

		before do
			req = double(:headers => { 'authorization' => user.auth_token })
			allow(app_controller).to receive(:request).and_return(req)
		end
		
		it 'returns the user from the authorization header' do	
		expect(app_controller.current_user).to eq (user)
	  end
	end


	describe '#Authenticable_with_token!' do
		controller do
			before_action :Authenticable_with_token!

			def restricted_action; end	
		end
		
    context	'when there is no user logged in' do
    	before do
    		allow(app_controller).to receive(:current_user).and_return(nil)
    		routes.draw { get 'restricted_action' => 'anonymos#restricted_action' }
    		get :restricted_action
      end	

       it 'returns status code 401' do
       		expect(response).to have_http_status(401)
       end
       		
       it 'returns the json data for the errors' do
       	expect(jason_body).to have_key(:errors)
			 end
		 end
	 end	


	describe '#user_logged_in?' do
    context 'when there is a user logged in' do
      before do
        user = create(:user)
        allow(app_controller).to receive(:current_user).and_return(user)
      end

      it { expect(app_controller.user_logged_in?).to be true }
    end
    
    context 'when there is no user logged in' do
      before do        
        allow(app_controller).to receive(:current_user).and_return(nil)
      end

      it { expect(app_controller.user_logged_in?).to be false }
    end
  end
end