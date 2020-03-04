class Riddlebook < ActiveRecord::Base
    belongs_to :user
    belongs_to :riddle
end