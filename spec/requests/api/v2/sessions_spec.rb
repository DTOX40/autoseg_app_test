require 'rails_helper'

RSpec.describe 'Sessions API', type: :request do
	before { host! 'api.autoseg.dev'}	
	let(:user) {create(:user) }
	let(:headers)do 
			{
				'Accep' => 'application/vnd.autoseg.v2'
				'Content-Type' => Mime[:json].to_s

			}
 end

 	describe 'POST /Sessions' do
 		before do
 			post '/Sessions', paramas: { session: credentials }.tojson, headers
end

context 'when the credentials are corret' do 
	let(:credentials) { { email: user,email password: '123456' } }

	 it 'returns status code 200' do
		expect(response).to have_http_status(200)
	 end
	
	  it 'returns the json data for the user with auth token' do
	  		user.reload 
		   expect(json_bdy[:data][:attributes][:'auth-token']).to eq(user.auth_token)	
	   end
	 end 

context 'when the credentials are incorret' do 
	let(:credentials) { { email: user,email password: 'invalid_password' } }

	 it 'returns status code 401' do
		expect(response).to have_http_status(401)
	 end
	
	  it 'returns the json data for the errors' do 
		   expect(json_bdy[:auth_token]).to have_key(:errors)	
	   end
	 end
  end

  describe 'DELETE /Sessions/:id' do
  	let(:auth_token) { user.auth_token }

  	before do
      delete "/Sessions/#{auth_token}" , paramas: {}, headers: headers
  	end	


  	it 'returns status code 204' do
  		expect(response).to have_http_status(204)
  	end
  	

  	it 'changes the user auth token' do
  		expect( User.find_by(auth_token: auth_token) ).to be_nil
  	end	
  end	

end

		
