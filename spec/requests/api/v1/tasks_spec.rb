require 'rails_helper'

Rspec.descibe 'Task API' do 
	before { host! 'api.autoseg.test'}

let!(:user) { create(:user) }
let(:headers) do
	{
		'Content-Type' => Mime[:json].to_s,
		'Accept' => 'application/vnd.autoseg.v1',
		'Autorization' => user.auth_token
	}	
end


 describe 'GET /tasks' do
   before do
   		create_list(:task, 5, user_id: user_id)
   		get '/tasks', params: {}, headers: headers
   	end

    it 'returns status code 200' do
    	expect(response).to have_http_status(200)
    end

   it 'returns 5 task from database' do
   		expect(json_body[:task].cout).to eq(5)
  
   end
 	end
end