class RecipesController < ApplicationController
  before_action :set_recipe, only: %i[ show edit update destroy ]

  # GET /recipes or /recipes.json
  def index
    @recipes = Recipe.all
  end

  # GET /recipes/1 or /recipes/1.json
  def show
  end

  # GET /recipes/new
  def new
    @recipe = Recipe.new
  end

  # GET /recipes/1/edit
  def edit
  end

  # POST /recipes or /recipes.json
    def create
    @recipe = current_user.recipes.build(recipe_params)

    if @recipe.save
      begin
        process_ingredients(params[:ingredients])
        process_tags(params[:tags])
        redirect_to @recipe, notice: "Recipe was successfully created."
        
      rescue => e

        @recipe.errors.add(:base, "Error when saving ingredients/tags: #{e.message}")
        @recipe.destroy
        render :new, status: :unprocessable_entity
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /recipes/1 or /recipes/1.json
  def update
    if @recipe.update(recipe_params)
      redirect_to @recipe, notice: "Recipe was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /recipes/1
  def destroy
    @recipe.destroy!
    redirect_to recipes_url, notice: "Recipe was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recipe
      @recipe = Recipe.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def recipe_params
      params.require(:recipe).permit(:title, :instructions, :prep_time, :cook_time, :is_private, :calories)
    end

    def process_ingredients(ingredients_data)
      ingredients_data.each do |key, data|
        next if data[:name].blank?
        ingredient = Ingredient.find_or_create_by!(name: data[:name].strip.capitalize)

        @recipe.recipe_ingredients.create!(
          ingredient: ingredient,
          amount: data[:amount],
          unit: data[:unit]
        )        
      end
    end

    def process_tags(tag_ids)
      tag_ids = Array(tag_ids).compact_blank
      tag_ids.each do |tag_id|
        @recipe.recipe_tags.create!(
          tag_id: tag_id
        )        
      end
    end

end
