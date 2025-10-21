class AddIndexesForMcp < ActiveRecord::Migration[8.0]
  def change
    # Companies indexes for search performance
    add_index :companies, :name unless index_exists?(:companies, :name)
    add_index :companies, :email unless index_exists?(:companies, :email)

    # Contacts indexes for search performance
    add_index :contacts, :first_name unless index_exists?(:contacts, :first_name)
    add_index :contacts, :last_name unless index_exists?(:contacts, :last_name)
    add_index :contacts, :email unless index_exists?(:contacts, :email)

    # Deals indexes for filtering and sorting
    add_index :deals, :stage unless index_exists?(:deals, :stage)
    add_index :deals, :created_at unless index_exists?(:deals, :created_at)
  end
end
