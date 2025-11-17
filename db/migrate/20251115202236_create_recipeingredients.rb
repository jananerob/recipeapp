class CreateRecipeingredients < ActiveRecord::Migration[7.1]
  def change
    create_table :recipeingredients do |t|
      t.references :recipe, null: false, foreign_key: true
      t.references :ingredient, null: false, foreign_key: true
      t.float :amount
      t.integer :unit

      t.timestamps
    end
  end
end
