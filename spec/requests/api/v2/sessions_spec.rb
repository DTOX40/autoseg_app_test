require 'rails_helper'

RSpec.describe 'Sessions API', type: :request do
	before { host! 'api.autoseg.dev'}	
	let!(:user) {create(:user) }
	let!(:auth_data) { user.create_new_token}
	let(:headers)do 
		{
			'Accep' => 'application/vnd.autoseg.v2'
			'Content-Type' => Mime[:json].to_s
			'access-token' => auth_data['access-token'],
      'uid' => auth_data['uid'],
      'client' => auth_data['client']
		}
 end

 	describe 'POST /auth/sing_in' do
 		before do
 			post '/auth/sing_in', paramas: credentials.tojson, headers: headers
end

context 'when the credentials are corret' do 
	let(:credentials) { { email: user,email password: '123456' } }

	 it 'returns status code 200' do
		expect(response).to have_http_status(200)
	 end
	
	  it 'returns the athentication data in the headers' do
	  	expect(response.headers).to have_key('access-token')
	  	expect(response.headers).to have_key('uid')
	  	expect(response.headers).to have_key('client')
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

  describe 'DELETE /auth/sing_out' do
  	let(:auth_token) { user.auth_token }

  	before do
      delete '/auth/sing_out' , paramas: {}, headers: headers
  	end	


  	it 'returns status code 200' do
  		expect(response).to have_http_status(200)
  	end
  	

  	it 'changes the user auth token' do
  		user.reload
  		expect( user.valid_token?(auth_data['access-token'],auth_data['client']) ).to eq(false)
  	end	
  end	
end

		
