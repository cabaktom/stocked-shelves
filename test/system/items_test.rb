require "application_system_test_case"

class ItemsTest < ApplicationSystemTestCase
  setup do
    @item = items(:one)
  end

  test "visiting the index" do
    visit items_url
    assert_selector "h1", text: "Items"
  end

  test "should create item" do
    visit items_url
    click_on "New item"

    fill_in "List", with: @item.list_id
    fill_in "Product", with: @item.product_id
    fill_in "User", with: @item.user_id
    fill_in "Expiration", with: @item.expiration
    check "Expired" if @item.expired
    fill_in "Quantity", with: @item.quantity
    click_on "Create Item"

    assert_text "Item was successfully created"
    click_on "Back"
  end

  test "should update Item" do
    visit item_url(@item)
    click_on "Edit this item", match: :first

    fill_in "List", with: @item.list_id
    fill_in "Product", with: @item.product_id
    fill_in "User", with: @item.user_id
    fill_in "Expiration", with: @item.expiration
    check "Expired" if @item.expired
    fill_in "Quantity", with: @item.quantity
    click_on "Update Item"

    assert_text "Item was successfully updated"
    click_on "Back"
  end

  test "should destroy Item" do
    visit item_url(@item)
    click_on "Destroy this item", match: :first

    assert_text "Item was successfully destroyed"
  end
end
