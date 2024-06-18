require 'test_helper'
class ProductsControllerTest < ActionDispatch::IntegrationTest
  def setup
    login
  end
  test 'render all products' do
    get products_path
    assert_response :success
    assert_select '.product', 12
    assert_select '.category', 11
    end

  test 'render a list of products filtered by category' do
    get products_path(category_id: categories(:phones).id)
    assert_response :success
    assert_select '.product', 0
    end

  test 'render a list of products filtered by min_price and max_price' do
    get products_path(min_price: 120, max_price: 200)
    assert_response :success
    assert_select '.product', 7
    end

  test 'search a product by query text' do
    get products_path(query_text: 'air')
    assert_response :success
    assert_select '.product', 1
    assert_select 'h2', 'MacBook Air'
    end

  test 'sort products by expensive prices first' do
    get products_path(order_by: 'expensive')

    assert_response :success
    assert_select '.product', 12
    assert_select '.products .product:first-child h2', 'Seat Panda clásico'
  end

  test 'sort products by cheapest prices first' do
    get products_path(order_by: 'cheapest')

    assert_response :success
    assert_select '.product', 12
    assert_select '.products .product:first-child h2', 'El hobbit'
  end

  test 'render one product' do
    get products_path(products(:tv))

    assert_response :success
    #assert_select '.title', 'Tv mala'
    #assert_select '.decription', 'Solo le falla la pantalla'
    #assert_select '.price', '190'
  end

  test 'render a new product form' do
    get new_product_path

    assert_response :success
    assert_select 'form'
  end

  test 'Allow to create a new product' do
    post products_path, params: {
      product: {
        title: 'Nuevo producto',
        description: 'Se ve bien',
        price: 95,
        category_id: categories(:phones).id
      }
    }
    assert_redirected_to products_path
    assert_equal flash[:notice], 'Product was successfully created.'
    end

  test 'does not allow to create a new product with empty fields' do
    post products_path, params: {
      product: {
        title: '',
        description: 'Se ve bien',
        price: 95
      }
    }
    assert_response :unprocessable_entity
  end

  test 'render an edit product form' do
    get edit_product_path(products(:ps5))

    assert_response :success
    assert_select 'form'
  end

  test 'allow to update a product' do
    patch product_path(products(:ps5)), params: {
      product: {
        price: 96
      }
    }

    assert_redirected_to products_path
    assert_equal flash[:notice], 'Product was successfully updated.'
  end


  test 'does not allow to update a product with an invalid field' do
    patch product_path(products(:ps5)), params: {
      product: {
        price: nil
      }
    }

    assert_response :unprocessable_entity
  end

  test 'allow to destroy a product' do
    assert_difference('Product.count', -1) do
      delete product_path(products(:ps5))
    end
    assert_redirected_to products_path
    assert_equal flash[:notice], 'Product was successfully destroyed.'
  end

end

