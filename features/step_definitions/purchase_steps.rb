Given /^a song called "([^"]*)" with a "([^"]*)" price of "([^"]*)"$/ do |song_title, format, price|
  song = Song.create(:title => song_title, "#{format}_price" => price.to_money)
end

When /^a user purchases "([^"]*)" in "([^"]*)" format$/ do |song_title, format|
  song = Song.where(:title => song_title).first
  @purchase ||= Purchase.create
  @purchase.purchase_items.create(:song => song, :format => format)
end

Then /^the total price of the purchase should be "([^"]*)"$/ do |price|
  @purchase.reload.price.should == price.to_money
end

Given /^that the exchange rate of "([^"]*)" to "([^"]*)" is "([^"]*)"$/ do |currency_1, currency_2, exchange_rate|
  unless (@test_bank)
    @test_bank = EuCentralBank.new
    @test_bank.update_rates(Rails.root + 'spec/test_exchange_rates.xml')
    EuCentralBank.stubs(:new => @test_bank)
    @test_bank.stubs(:update_rates)
  end
  @test_bank.set_rate(currency_2, currency_1, exchange_rate.to_f)
end
