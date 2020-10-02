class CreateIssueCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :issue_categories do |t|
      t.string  :sector
      t.integer :scorecard_category
      t.integer :year

      t.timestamps
    end
  end
end
