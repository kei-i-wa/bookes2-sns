class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  validates :content, presence: true 
  # コンテントカラムを作成済みです。
end
