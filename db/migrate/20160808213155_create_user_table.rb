class CreateUserTable < ActiveRecord::Migration
  def change
    create_table :users do |column|
      column.string :username
      column.string :password
      column.string :email
    end
  end
end
