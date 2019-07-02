require 'rails_helper'

RSpec.describe User, type: :model do
	let(:user) {build(:user) }

it { is_expected.to validate_presence_of(:email) }	
it { is_expected.to uniqueness_of(:email).case_insensitive }
it { is_expected.to validate_confirmation_of(:password) }
it { is_expected.to allow_value('autoseg@autoseg.com').for(:email) }
it { is_expected.to validate_uniquess_of(:auth_token) }


describe '#info' do
  it 'returns email and created_at' do
  	user.save!
  	allow(Devise).to receive(:friendly_token).and_return('abc123xyzTOKEN')
	 expected(user.info).to eq("#{user.email} - #{user.created_at} - token: #{Devise.friendly_token}" ) 
   end
  end
end 