class CreateAdyenNotifications < ActiveRecord::Migration

  def self.up
    Adyen::Notification::Migration.up
  end

  def self.down
    Adyen::Notification::Migration.down
  end
end
