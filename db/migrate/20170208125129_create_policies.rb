class CreatePolicies < ActiveRecord::Migration
  def self.up
    create_table :policies do |t|
      t.string :name,        null: false
      t.string :title,       null: false
      t.text   :description, null: false
      t.text   :the_policy,  null: false

      t.timestamps
    end
  end

  def self.down
    drop_table :policies
  end
end
