class AddRequestBatchIdToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :request_batch_id, :text, array: true
  end
end
