class AddWebsiteUrlToLocalNgos < ActiveRecord::Migration[6.0]
  def change
    add_column :local_ngos, :website_url, :string
  end
end
