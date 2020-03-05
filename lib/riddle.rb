class Riddle < ActiveRecord::Base
    has_many :riddlebooks
    has_many :users, through: :riddlebooks
    validates :title, format: {with: /[a-zA-Z]/, message: 'Invalid Response. Must be String'}
    validates :context, format: {with: /[a-zA-Z]/, message: 'Invalid Response. Must be String'}
    validates :answer, format: {with: /[a-zA-Z]/, message: 'Invalid Response. Must be String'}
end