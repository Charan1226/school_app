class CreateBatchesUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :batches_users do |t|
      t.integer :user_id
      t.integer :batch_id

      t.timestamps
    end
  end
end
