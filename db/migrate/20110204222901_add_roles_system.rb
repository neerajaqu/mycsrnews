class AddRolesSystem < ActiveRecord::Migration
  def self.up
    create_table :roles, :force => true do |t|
      t.string    :name
      t.string    :authorizable_type
      t.integer   :authorizable_id

      t.timestamps
    end

    create_table :roles_users, :id => false, :force => true do |t|
      t.references :user
      t.references :role

      t.timestamps
    end
  end

  def self.down
    drop_table :roles
    drop_table :roles_users
  end
end
