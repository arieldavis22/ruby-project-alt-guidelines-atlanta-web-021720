class User < ActiveRecord::Base
    has_many :riddlebooks
    has_many :riddles, through: :riddlebooks
    validates :name, format: {with: /[a-zA-Z]/, message: 'Invalid Response. Must be String'}
end