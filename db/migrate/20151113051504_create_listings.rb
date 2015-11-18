class CreateListings < ActiveRecord::Migration
  def change
    create_table :listings do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.string :name
      t.text :description
      t.string :slug
      t.boolean :active

      t.timestamps null: false
    end
  end
end
