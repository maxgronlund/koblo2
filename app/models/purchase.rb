class Purchase < ActiveRecord::Base
  belongs_to :user
  has_many :purchase_items

  def update_price!
    # Update the exchange rates
    eu_bank = EuCentralBank.new
    Money.default_bank = eu_bank

    # Cache the rates for 24 hours
    rates_file = Rails.root + "tmp/rates.xml"
    if !File.exists?(rates_file) || File.new(rates_file).ctime < 1.day.ago
      eu_bank.save_rates(rates_file)
    end

    eu_bank.update_rates(rates_file)

    sum = purchase_items.map(&:price).inject(&:+)
    if (sum)
      self.price = sum.exchange_to('EUR')
    else
      self.price = Money.new(0)
    end

    save
  end

  composed_of :price,
    :class_name => "Money",
    :mapping => [%w(price_in_cents cents), %w(currency currency_as_string)],
    :constructor => Proc.new { |cents, currency| Money.new(cents || 0, currency || Money.default_currency) }
end
