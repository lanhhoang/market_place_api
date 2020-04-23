require 'rails_helper'

RSpec.describe Product, type: :model do
  let(:product) { build(:product) }

  subject { product }

  it { is_expected.to respond_to(:title) }
  it { is_expected.to respond_to(:price) }
  it { is_expected.to respond_to(:published) }
  it { is_expected.to respond_to(:user_id) }

  it { is_expected.not_to be_published }

  it { should belong_to :user }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:price) }
  it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
  it { should validate_presence_of(:user_id) }

  describe '.filter_by_title' do
    let!(:product1) { create(:product, title: 'A plasma TV') }
    let!(:product2) { create(:product, title: 'Fastest laptop') }
    let!(:product3) { create(:product, title: 'CD player') }
    let!(:product4) { create(:product, title: 'LCD TV') }

    context "when a 'TV' title pattern is sent" do
      it 'returns 2 products matching' do
        expect(Product.filter_by_title('TV').size).to eq 2
      end

      it 'returns products matching' do
        expect(Product.filter_by_title('TV').sort).to match_array([product1, product4])
      end
    end
  end

  describe '.above_or_equal_to_price' do
    let!(:product1) { create(:product, price: 100) }
    let!(:product2) { create(:product, price: 50) }
    let!(:product3) { create(:product, price: 150) }
    let!(:product4) { create(:product, price: 99) }

    it 'returns products which are above or equal to the price' do
      expect(Product.above_or_equal_to_price(100).sort).to match_array([product1, product3])
    end
  end

  describe '.below_or_equal_to_price' do
    let!(:product1) { create(:product, price: 100) }
    let!(:product2) { create(:product, price: 50) }
    let!(:product3) { create(:product, price: 150) }
    let!(:product4) { create(:product, price: 99) }

    it 'returns products which are below or equal to the price' do
      expect(Product.below_or_equal_to_price(99).sort).to match_array([product2, product4])
    end
  end

  describe '.recent' do
    let!(:product1) { create(:product, price: 100) }
    let!(:product2) { create(:product, price: 50) }
    let!(:product3) { create(:product, price: 150) }
    let!(:product4) { create(:product, price: 99) }

    before do
      product2.touch
      product3.touch
    end

    it 'returns the most updated records' do
      expect(Product.recent).to match_array([product3, product2, product4, product1])
    end
  end
end
