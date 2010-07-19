class AddShortTitleToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :short_title, :string
    { 1 => 'why', 2 => 'who', 3 => 'terms', 4 => 'help' }.each do |id, short_title|
      page = Page.find_by_id(id)
      page.update_attribute(:short_title, short_title) if page
    end
  end

  def self.down
    remove_column :pages, :short_title
  end
end
