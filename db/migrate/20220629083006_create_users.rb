class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :eth_address
      t.string :eth_nonce
      t.string :username

      t.timestamps
    end
  end
end
