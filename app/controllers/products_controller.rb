class ProductsController < ApplicationController

  """
  Retrieves all products with attached photos from the database.
  """
  def index
    @categories = Category.order(name: :asc).load_async
    @products = Product.with_attached_photo
    if params[:category_id]
      @products = @products.where(category_id: params[:category_id])
    end

    if params[:min_price].present?
      @products = @products.where("price >= ?", params[:min_price])
    end

    if params[:max_price].present?
      @products = @products.where("price <= ?", params[:max_price])
    end

    if params[:query_text].present?
      @products = @products.search_full_text(params[:query_text])
    end

    order_by= Product::ORDER_BY.fetch(params[:order_by]&.to_sym, Product::ORDER_BY[:newest])
    @products = @products.order(order_by)

    @pagy, @products = pagy_countless(@products, items: 12)

  end

  def show
    product
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to products_path, notice: t('.create.success')
    else
      render :new, :status => :unprocessable_entity
    end
  end

  def edit
    product
  end

  def update
    if product.update(product_params)
      redirect_to products_path, notice: t('.update.success')
    else
      render :edit, :status => :unprocessable_entity
    end
  end

  def destroy
    product.destroy
    redirect_to products_path, notice: t('.destroy.success'), status: :see_other
  end

  def product
    @product = Product.find(params[:id])
  end

  private
  def product_params
    params.require(:product).permit(:title, :description, :price, :photo, :category_id)
  end

end

