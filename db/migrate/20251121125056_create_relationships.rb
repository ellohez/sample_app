class CreateRelationships < ActiveRecord::Migration[7.0]
  def change
    create_table :relationships do |t|
      t.integer :follower_id
      t.integer :followed_id

      t.timestamps
    end
    # Will need to find relationships by either follower_id or followed_id
    add_index :relationships, :follower_id
    add_index :relationships, :followed_id
    # Multiple-key index enforces uniqueness on follower_id, followed_id pairs
    # so that a user can't follow another user more than once
    add_index :relationships, %i[follower_id followed_id], unique: true
  end
end
