class RemoveAttachmentFromAnswers < ActiveRecord::Migration
  def up
    remove_column :answers, :attachment
      end

  def down
    add_column :answers, :attachment, :string
  end
end
