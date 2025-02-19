class CreateLearningResources < ActiveRecord::Migration[7.1]
  def change
    create_table :learning_resources do |t|
      t.string :title
      t.text :description
      t.text :publisher
      t.string :image_url

      t.timestamps
    end
  end
end
