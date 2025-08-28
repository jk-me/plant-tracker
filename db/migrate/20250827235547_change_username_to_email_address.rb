class ChangeUsernameToEmailAddress < ActiveRecord::Migration[8.0]
  def change
    change_table :users do |t|
      t.rename :username, :email_address
    end
  end
end
