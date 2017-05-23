require 'test_helper'

class UserGroupTest < ActiveSupport::TestCase

  test "new user_balance_entry updates user_group balance only when approved" do
    one = groups(:one)
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
    one = groups(:one)
    james = users(:james)
    ug = UserGroup.create!(user: james, group: one)

    entry = UserBalanceEntry.create!(user_group: ug, value: 10, approved: true)

    ug.reload

    assert_equal 10.0, ug.balance
  end

  test "new user_balance_entry updates user_group balance only when approved after value changed" do
    one = groups(:one)
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
    one = groups(:one)
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


end
