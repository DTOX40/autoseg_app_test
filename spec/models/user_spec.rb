require 'rails_helper'

RSpec.describe User, type: :model do
	let(:user) {build(:user) }

	it { is_expected.to have_many(:tasks).dependent(:destroy) }

it { is_expected.to validate_presence_of(:email) }	
it { is_expected.to uniqueness_of(:email).case_insensitive }
it { is_expected.to validate_confirmation_of(:password) }
it { is_expected.to allow_value('autoseg@autoseg.com').for(:email) }
it { is_expected.to validate_uniquess_of(:auth_token) }


describe '#info' do
  it 'returns email and created_at' do
  	user.save!
  	allow(Devise).to receive(:friendly_token).and_return('abc123xyzTOKEN')
	 expected(user.info).to eq("#{user.email} - #{user.created_at} - token: #abc123xyzTOKEN" ) 
   end
 end  


   describe '#generate_authentication_token!' do
 		it 'generaters a unique auth token'

 		it 'generaters auth token when the curret auth token alredy has been taken' do	
 			allow(Devise).to receive(:friendly_token).and_return('#abc123tokenxyz', '#abc123tokenxyz', '#abc123456789')
 				existing_user = created(:user) 
 			user.generate_authentication_token!


 			expected(user.auth_token).not_to eq(existing_user.auth_token)
    end
  end 
end