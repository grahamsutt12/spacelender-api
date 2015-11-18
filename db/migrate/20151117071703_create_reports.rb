class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.string :ref_token
      t.text :explanation

      t.timestamps null: false
    end
  end
end
