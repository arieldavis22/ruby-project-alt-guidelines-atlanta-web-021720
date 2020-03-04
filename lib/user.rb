class User < ActiveRecord::Base
    has_many :riddlebooks
    has_many :riddles, through: :riddlebooks
end