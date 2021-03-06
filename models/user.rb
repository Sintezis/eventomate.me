class User
  include DataMapper::Resource

  property :id, 					Serial
  property :email, 				String,   :length => 255
  property :password, 		String,   :length => 255
  property :token, 				String,   :length => 255
  property :recover_code, String,   :length => 255
  property :created_at,   DateTime
  property :created_on,   Date   
  property :updated_at,   DateTime
  property :updated_on,   Date

  has 1, :account
  has n, :attendees
  has n, :owns
  has n, :comments
  has n, :events, :through => :owns
  has n, :events, :through => :attendees
  has n, :events, :through => :comments
  
end