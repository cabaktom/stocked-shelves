# frozen_string_literal: true

require 'test_helper'

class ColorTest < ActiveSupport::TestCase
  setup do
    @color = colors(:one)
    @user = users(:one)
  end

  test 'valid color' do
    assert @color.valid?
  end

  test 'invalid without name' do
    @color.name = nil
    assert_not @color.valid?, 'Color is valid without a name'
    assert_not_nil @color.errors[:name], 'no validation error for name present'
  end

  test 'invalid without hex_code' do
    @color.hex_code = nil
    assert_not @color.valid?, 'Color is valid without a hex_code'
    assert_not_nil @color.errors[:hex_code], 'no validation error for hex_code present'
  end

  test 'invalid with incorrect hex_code format' do
    invalid_hex_codes = ['GGG', '#1234Z', '123456', '']
    invalid_hex_codes.each do |invalid_hex|
      @color.hex_code = invalid_hex
      assert_not @color.valid?, "#{invalid_hex.inspect} should be invalid"
    end
  end

  test 'valid with correct hex_code format' do
    valid_hex_codes = ['#123', '#abc', '#123456', '#abcdef']
    valid_hex_codes.each do |valid_hex|
      @color.hex_code = valid_hex
      assert @color.valid?, "#{valid_hex.inspect} should be valid"
    end
  end

  test 'should have many lists' do
    assert_respond_to @color, :list, 'Color does not have a lists association'
  end

  test 'belongs to user' do
    assert_respond_to @color, :user, 'Color does not belong to a user'
  end
end
