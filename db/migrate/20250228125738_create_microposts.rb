class CreateMicroposts < ActiveRecord::Migration[7.0]
  def change
    create_table :microposts do |t|
      t.text :content
      # references automatically adds a user_id column (along with an index and a foreign key reference)
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    # Arrange for Rails to create a multiple key index on the created_at and user_id columns
    # We will be retrieving all the microposts associated with a given
    # user in reverse order of creation, so we include the created_at column
    add_index :microposts, %i[user_id created_at]
  end
end
