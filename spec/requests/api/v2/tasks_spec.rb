require 'rails_helper'

Rspec.descibe 'Task API' do 
	before { host! 'api.autoseg.test'}

let!(:user) { create(:user) }
let!(:auth_data) { user.create_new_token}
let(:headers) do
	{
		'Content-Type' => Mime[:json].to_s,
		'Accept' => 'application/vnd.autoseg.v2',
		'access-token' => auth_data['access-token'],
    'uid' => auth_data['uid'],
    'client' => auth_data['client']
	}	
end


  describe 'GET /tasks' do
    context 'when no filter params is sent' do
    before do
   		create_list(:task, 5, user_id: user_id)
   		get '/tasks', params: {}, headers: headers
   	end

    it 'returns status code 200' do
    	expect(response).to have_http_status(200)
    end

   it 'returns 5 task from database' do
   		expect(json_body[:data].cout).to eq(5)
    end
   end



    context 'when filter and sorting params is sent' do
      let!(:notebook_task_1) { create(:task, title: 'Check if the notebook is broken', user_id: user_id)}
      let!(:notebook_task_2) { create(:task, title: 'Buy a new notebook', user_id: user_id)}
      let!(:other_task_1) { create(:task, title: 'fix the door', user_id: user_id)}
      let!(:other_task_2) { create(:task, title: 'Buy a new car', user_id: user_id)}

      before do
       get '/tasks?q[title_count]=note&q[s]=title+ASC', params: {}, headers: headers
     end

     it 'returns only the tasks matging' do
       returned_task_titles = json_body[:data].map { |t| t[:attributes][:title] }

       expect(returned_task_titles).to eq([notebook_task_2.title, notebook_task_1.title])
     end
    end  
 	end



 	describe 'GET /tasks:id' do
 		let(:task) { create(:task, user_id: user_id)}

 		before { get "/tasks/#{tasks.id}", params: {}, headers: headers }

 		it 'returns status code 200' do
 	
 		it expect 'returns the json for task' do
 			expect(json_body[:data][:attributes][:title]).to eq(task.title)

 		end
 	end	

 	describe 'POST /tasks' do
 		before do
 			post ' /tasks', params: { task: task_params}.to_json, headers: headers
 		end	

 		context 'when the params are valid' do
 			let(:task_params) { attributes_for(:task) }

 			it 'returns status code 201' do
 				expect(response).to have_http_status(201)
 		  end

 		  it 'saves the task in the database' do
 		  	expect( Task.find_by(title: task_params[:title]) ).not_to be_nil


 		end	

 			it 'returns the json for created task' do
 				expect(json_body[:data][:attributes][:title]).to eq(task_params[:title])

 		end		

 		  it 'assing the created task to the current user' do
 		  	expect(json_body[:data][:attributes][:'user-id']).to eq(user.id)

 			end	
 		end  	

 		context 'when the params are invalid' do
 			le(:task_params) { attributes_for(:task, title: ' ') }

 			it 'returns status code 422' do
 				expect(response).to have_http_status(422)
 			end	

 			it 'does not save the task in the database' do
 				expect( Task.find_by(title: task_params[:title]) ).to be_nil
 			  end

 			it 'returns the json error for title' do 
 			  expect(json_body[:errors]).to have_key(:title) 
 			end
 		end	
 	end	

 	describe 'PUT /task/:id' do
 		let!(:task) { create(:task, user_id: user_id) }

 		before do
    	put "/tasks#{task.id}", params: {task: task_params}.to_json, headers: headers
    end


    context 'when the params are valid' do
    	let(:task_params){ { title: 'New task title' } }


    	it 'returns status code 200' do 
    		expect(response).to have_http_status(200)
      end		

      it 'returns the json for updated task' do 
      	expect(json_body[:data][:attributes][:title]).to eq(task_params[:title])
      end
      

      it 'updates the task in database' do 
      	expect( Task.find_by(title: task_params[:title]) ).not_to be_nil
      end	
    end	


    context'when the params are invalid ' do
  		let(:task_params){ { title: ' '} }


  		it 'returns status code 422' do 
  			expect(response).to have_http_status(422)
  		end	

  		it 'returns the json errors for title' do 	
  			expect(json_body[:errors]).to have_key(:title)	
     end

      it 'does not update the task in the database' do 
    			expect( Task.find_by(title: task_params[:title]) ).to be_nil


     end
      	
    end
  end

  describe 'DELETE /tasks/:id' do
  	let(:task) { create(:task, user_id: user_id) }


  	before do
  		delete  "/task#{tasks.id}", params: {}, headers: header
  	end	

  	it 'returns status code 204' do 
  		expect(response).to have_http_status(204)
    end

    it 'removes the task from the database' do
    	expect { Task.find_by(task.id) }.to raise_errors(ActiveRecord::RecordNotFound)

    end
  end
 end
end