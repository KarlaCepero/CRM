class CreateActivities < ActiveRecord::Migration[8.0]
  def change
    create_table :activities do |t|
      t.string :activity_type
      t.text :description
      t.datetime :due_date
      t.string :status
      t.references :activitable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
