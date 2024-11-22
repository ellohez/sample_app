# frozen_string_literal: true

class AddRememberDigestToUsers < ActiveRecord::Migration[7.0]
  # As we won't ever retrieve users by the digest, there's no need for an index
  def change
    add_column :users, :remember_digest, :string
  end
end
