# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
  end

  test 'valid user' do
    assert @user.valid?
  end

  test 'invalid without email' do
    @user.email = nil
    assert_not @user.valid?, 'User is valid without an email'
    assert_not_nil @user.errors[:email], 'no validation error for email present'
  end

  test 'invalid without username' do
    @user.username = nil
    assert_not @user.valid?, 'User is valid without a username'
    assert_not_nil @user.errors[:username], 'no validation error for username present'
  end

  test 'username uniqueness' do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?, 'User is valid with a duplicate username'
    assert_not_nil duplicate_user.errors[:username], 'no validation error for duplicate username'
  end

  test 'email formatted correctly' do
    @user.email = 'invalid_email'
    assert_not @user.valid?, 'User is valid with incorrectly formatted email'
  end

  test 'username format validation' do
    @user.username = 'Invalid Username'
    assert_not @user.valid?, 'User is valid with incorrectly formatted username'
  end

  test 'has many associations' do
    assert_respond_to @user, :lists, 'User does not have lists association'
    assert_respond_to @user, :colors, 'User does not have colors association'
    assert_respond_to @user, :products, 'User does not have products association'
    assert_respond_to @user, :items, 'User does not have items association'
    assert_respond_to @user, :notifications, 'User does not have notifications association'
  end

  test 'destroys associated records when deleted' do
    @user.save! # the user has 2 associated lists
    @user.lists.create!(name: 'Test List') # add another list
    assert_difference('List.count', -3, 'Deleting user did not destroy associated lists') do
      @user.destroy
    end
  end

  test 'find_for_database_authentication with username' do
    @user.save!
    authenticated_user = User.find_for_database_authentication(login: @user.username)
    assert_equal @user, authenticated_user, 'User could not be authenticated with username'
  end

  test 'find_for_database_authentication with email' do
    @user.save!
    authenticated_user = User.find_for_database_authentication(login: @user.email)
    assert_equal @user, authenticated_user, 'User could not be authenticated with email'
  end
end
