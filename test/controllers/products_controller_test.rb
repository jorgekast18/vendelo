require 'test_helper'
class ProductsControllerTest < ActionDispatch::IntegrationTest
  test 'render all products' do
    get products_path
    assert_response :success
    assert_select '.product', 2
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
        price: 95
      }
    }
    assert_redirected_to products_path
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
end

