class AddIndexRefTokenToReports < ActiveRecord::Migration
  def change
    add_index :reports, :ref_token
  end
end
