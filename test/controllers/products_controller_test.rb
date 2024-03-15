require 'test_helper'
class ProductsControllerTest < ActionDispatch::IntegrationTest
  test 'render all products' do
    get products_path
    assert_response :success
    assert_select '.product', 3
    assert_select '.category', 4
    end

  test 'render a list of products filtered by category' do
    get products_path(category_id: categories(:phones).id)
    assert_response :success
    assert_select '.product', 1
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
    get edit_product_path(products(:phone))

    assert_response :success
    assert_select 'form'
  end

  test 'allow to update a product' do
    patch product_path(products(:phone)), params: {
      product: {
        price: 96
      }
    }

    assert_redirected_to products_path
    assert_equal flash[:notice], 'Product was successfully updated.'
  end


  test 'does not allow to update a product with an invalid field' do
    patch product_path(products(:phone)), params: {
      product: {
        price: nil
      }
    }

    assert_response :unprocessable_entity
  end

  test 'allow to destroy a product' do
    assert_difference('Product.count', -1) do
      delete product_path(products(:phone))
    end
    assert_redirected_to products_path
    assert_equal flash[:notice], 'Product was successfully destroyed.'
  end

end

