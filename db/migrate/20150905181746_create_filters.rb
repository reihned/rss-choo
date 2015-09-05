class CreateFilters < ActiveRecord::Migration
  def change
    create_table :filters do |t|
      t.string :feed_url
      t.text :keywords

      t.timestamps null: false
    end
  end
end
