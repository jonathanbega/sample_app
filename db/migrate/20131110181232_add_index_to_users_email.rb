class AddIndexToUsersEmail < ActiveRecord::Migration
  def change
  	#add_index (name of table, column name, index)
  	add_index(:users, :email, unique: true)
  end
end
