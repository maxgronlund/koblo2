class AdyenNotification < ActiveRecord::Base
  belongs_to :user, :class_name => "User", :foreign_key => "merchant_reference"
  belongs_to :original_notification, :class_name => "AdyenNotification", :foreign_key => "original_reference", :primary_key => "psp_reference"

  def handle!
    if success?
      case event_code
      when 'AUTHORISATION'

        # A payment authorized successfully, so handle the payment
        # ...
        # flag the notification so we know that it has been processed
        # User.find(shopper_reference.to_i).renew_premium!(1.month)
        # time_of_premiumness = AMOUNTS.invert[(value * 100).to_i].months
        # User.find(merchant_reference.to_i).renew_premium!(time_of_premiumness)
        update_attribute(:processed, true)
      when 'CANCEL_OR_REFUND'
        # time_of_premiumness = AMOUNTS.invert[(original_notification.value * 100).to_i].months
        # User.find(merchant_reference.to_i).cancel_premium!(time_of_premiumness)
        update_attribute(:processed, true)
      when 'RECURRING_CONTRACT'
        update_attribute(:processed, true)
      end
    end
  end
end

