class Api::V2::TaskSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :done, :deadline, :user_id, :created_at, :update_at,
  			  :short_description


  def short_description
  	object.description[0..40]			  	
  end			  

  def is_late
  	Time.current > object.deadline if object.deadline.present?
  	end

   belongs_to :user_id
end
