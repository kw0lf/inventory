class ItemHistory < ActiveRecord::Base
  belongs_to :employee
  belongs_to :item
  belongs_to :parent, class_name: "Item"

  validates :item, presence: true
  validates :note, length: { maximum: 500 }

  scope :order_desending, -> { order('created_at DESC') }
end
