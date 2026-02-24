class Field < ApplicationRecord
  validates :name, presence: true
  validates :shape, presence: true

end
