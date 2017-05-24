require 'test_helper'

class UserGroupTest < ActiveSupport::TestCase

  test "new user_balance_entry updates user_group balance only when approved" do
    one = groups(:default_group)
    james = users(:james)

    assert_not UserGroup.exists?(user: james, group: one)

    ug = UserGroup.create!(user: james, group: one)

    assert_equal 0.0, ug.balance

    entry = UserBalanceEntry.create!(user_group: ug, value: 10, approved: false)

    ug.reload

    assert_equal 0.0, ug.balance

    entry.approved = true
    entry.save

    ug.reload

    assert_equal 10.0, ug.balance
  end

  test "new user_balance_entry updates user_group balance" do
    one = groups(:default_group)
    james = users(:james)
    ug = UserGroup.create!(user: james, group: one)

    UserBalanceEntry.create!(user_group: ug, value: 10, approved: true)

    ug.reload

    assert_equal 10.0, ug.balance
  end

  test "new user_balance_entry updates user_group balance only when approved after value changed" do
    one = groups(:default_group)
    james = users(:james)

    assert_not UserGroup.exists?(user: james, group: one)

    ug = UserGroup.create!(user: james, group: one)

    assert_equal 0.0, ug.balance

    entry = UserBalanceEntry.create!(user_group: ug, value: 10, approved: false)

    ug.reload

    assert_equal 0.0, ug.balance

    entry.value = 15
    entry.save

    ug.reload

    assert_equal 0.0, ug.balance

    entry.approved = true
    entry.save

    ug.reload

    assert_equal 15.0, ug.balance
  end

  test "user_balance_entry shall not change after approved" do
    one = groups(:default_group)
    james = users(:james)
    ug = UserGroup.create!(user: james, group: one)

    entry = UserBalanceEntry.create!(user_group: ug, value: 10, approved: false)

    entry.approved = true
    entry.save

    ug.reload

    assert_equal 10.0, ug.balance

    entry.value = 11
    exception = assert_raises(Exception) { entry.save! }

    assert_equal "Balance can't be updated after approved", exception.message

    ug.reload

    assert_equal 10.0, ug.balance
    assert_equal 10.0, UserBalanceEntry.find(entry.id).value
  end


  test "new approved entries update the balance" do
    bobs_group = user_groups(:bob)
    assert_equal 10, bobs_group.balance

    UserBalanceEntry.create!(user_group: bobs_group, value: 1, approved: true)

    bobs_group.reload
    assert_equal 11, bobs_group.balance

    UserBalanceEntry.create!(user_group: bobs_group, value: 2, approved: true)

    bobs_group.reload
    assert_equal 13, bobs_group.balance

    UserBalanceEntry.create!(user_group: bobs_group, value: -4.5, approved: true)

    bobs_group.reload
    assert_equal 8.5, bobs_group.balance

    e = UserBalanceEntry.create!(user_group: bobs_group, value: -0.5, approved: false)

    bobs_group.reload
    assert_equal 8.5, bobs_group.balance

    e.approved = true
    e.save!

    bobs_group.reload
    assert_equal 8, bobs_group.balance
  end


end
