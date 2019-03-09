class Relationship < ApplicationRecord
  belongs_to :user#, class_name: 'User'が省略されている
  #命名規則を変更しているため
  belongs_to :follow, class_name: 'User'
end
