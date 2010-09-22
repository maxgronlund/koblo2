class Money
  def currency_as_string
    currency.to_s
  end

  def currency_as_string=(value)
    # WARNING: this method might cause data inconsistency.
    # See http://github.com/FooBarWidget/money/issues/4#issue/4/comment/224930
    currency = Currency.wrap(value)
  end
end

