class Api::v2::BaseController < ApplicationController
	include DeviseTokenAuth::Concerns::SetUserByToken
	include Authenticable
end	