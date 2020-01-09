class CreateLoans < ActiveRecord::Migration[6.0]
  def change
    create_table :loans do |t|
      t.integer :principle
      t.decimal :interest
      t.string :name
      t.decimal :payment
      t.belongs_to :provider, null: false, foreign_key: true

      t.timestamps
    end
  end
end
