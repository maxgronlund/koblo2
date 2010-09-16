class AdyenController < ActionController::Base
  before_filter :authenticate

  # POST https://example.com/adyen/notify
  def notify
    Adyen::Notification::HttpPost.log(request)
    AdyenNotification.last.handle!
  rescue ActiveRecord::RecordInvalid => e
    # Validation failed, because of the duplicate check.
    # So ignore this notification, it is already stored and handled.
  ensure
    # Always return that we have accepted the notification
    render :text => '[accepted]'
  end
  protected 

  # Enable HTTP basic authentication
  def authenticate
    authenticate_with_http_basic do |username, password|
      username == 'koblo' && password == 'moo1ubi0ooT3Zo'
    end
  end
end

