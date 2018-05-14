class RemoveUnescessaryFromComments < ActiveRecord::Migration[5.1]
  def change
    remove_column :comments, :references, :string
    remove_column :comments, :post, :string
  end
end
