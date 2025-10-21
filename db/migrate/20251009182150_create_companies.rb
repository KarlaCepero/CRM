class CreateCompanies < ActiveRecord::Migration[8.0]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.text :address
      t.string :website
      t.string :industry

      t.timestamps
    end
  end
end
