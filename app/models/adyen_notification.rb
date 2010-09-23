class AdyenNotification < ActiveRecord::Base
  belongs_to :user, :class_name => "User", :foreign_key => "merchant_reference"
  belongs_to :original_notification, :class_name => "AdyenNotification", :foreign_key => "original_reference", :primary_key => "psp_reference"

  def handle!
    if success?
      case event_code
      when 'AUTHORISATION'
        Purchase.find(merchant_reference.to_i).complete!
        update_attribute(:processed, true)
      when 'CANCEL_OR_REFUND'
        Purchase.find(merchant_reference.to_i).uncomplete!
        update_attribute(:processed, true)
      when 'RECURRING_CONTRACT'
        Purchase.find(merchant_reference.to_i).complete!
        update_attribute(:processed, true)
      end
    end
  end
end

