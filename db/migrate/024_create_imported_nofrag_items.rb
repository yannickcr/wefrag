class CreateImportedNofragItems < ActiveRecord::Migration
  def self.up
    create_table :imported_nofrag_items do |t|
      t.integer  :topic_id
      t.integer  :remote_id
      t.string   :title
      t.string   :url
      t.text     :description
      t.datetime :published_at
      t.timestamps
    end

    add_index :imported_nofrag_items, :remote_id, :unique => true
  end

  def self.down
    drop_table :imported_nofrag_items
  end
end
