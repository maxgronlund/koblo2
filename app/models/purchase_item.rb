class PurchaseItem < ActiveRecord::Base
  belongs_to :purchase
  belongs_to :song

  before_create :update_price

  after_create :update_purchase_price

  scope :completed, joins(:purchase) & Purchase.completed

  def update_price
    self.price = song.send("#{format}_price")
  end

  def update_purchase_price
    purchase.update_price!
  end

  composed_of :price,
    :class_name => "Money",
    :mapping => [%w(price_in_cents cents), %w(currency currency_as_string)],
    :constructor => Proc.new { |cents, currency| Money.new(cents || 0, currency || Money.default_currency) }

  def multitrack?
    format == 'multitrack'
  end
end
