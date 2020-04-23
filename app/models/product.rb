class Product < ApplicationRecord
  belongs_to :user

  validates :title, :user_id, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }, presence: true

  scope :filter_by_title, ->(keyword) do
    where('lower(title) ILIKE ?', "%#{keyword.downcase}%")
  end
  scope :above_or_equal_to_price, ->(price) do
    where('price >= ?', price)
  end
  scope :below_or_equal_to_price, ->(price) do
    where('price <= ?', price)
  end
  scope :recent, -> { order(:updated_at) }

  def self.search(params = {})
    products = params[:product_ids].present? ? Product.find(params[:product_ids]) : Product.all

    products = products.filter_by_title(params[:keyword]) if params[:keyword]
    products = products.above_or_equal_to_price(params[:min_price]) if params[:min_price]
    products = products.below_or_equal_to_price(params[:max_price]) if params[:max_price]
    products = products.recent(params[:recent]) if params[:recent]

    products
  end
end
