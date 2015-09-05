class CreateFilter < ActiveRecord::Migration
  def change
    create_table :filters do |t|
      t.string  :feed_url
      t.text    :keywords
    end
  end
end
