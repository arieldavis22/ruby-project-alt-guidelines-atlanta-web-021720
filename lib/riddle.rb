class Riddle < ActiveRecord::Base
    has_many :riddlebooks
    has_many :users, through: :riddlebooks
end