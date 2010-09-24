class Purchase < ActiveRecord::Base
  belongs_to :user
  has_many :purchase_items

  after_save :trigger_zip_creation

  scope :completed, where(:completed => true)

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

  def trigger_zip_creation
    if completed?
      purchase_items.each do |purchase_item| 
        song = purchase_item.song
        Resque.enque(CreateMultitrackZipFile, song.id) if !song.multitrack_zip_file?
      end
    end
  end

  def complete!
    update_attribute(:completed, true)
  end

  def uncomplete!
    update_attribute(:completed, false)
  end
end
