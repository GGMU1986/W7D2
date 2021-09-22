class Album < ApplicationRecord
    validates :title, :year, :live, presence: true
end