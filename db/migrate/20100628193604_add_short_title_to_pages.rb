class AddShortTitleToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :short_title, :string
    Page.find(1).update_attribute(:short_title, 'why')
    Page.find(2).update_attribute(:short_title, 'who')
    Page.find(3).update_attribute(:short_title, 'terms')
    Page.find(4).update_attribute(:short_title, 'help')
  end

  def self.down
    remove_column :pages, :short_title
  end
end
