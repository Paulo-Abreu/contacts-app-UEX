class DropContactsTable < ActiveRecord::Migration[7.0]
  def up
    drop_table :contacts
  end

  def down
    create_table :contacts do |t|
      t.string :name
      t.string :address
      t.string :zipcode
      t.string :cpf
      t.string :phone
      t.timestamps
    end
  end
end
