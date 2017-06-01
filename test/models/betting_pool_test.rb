require 'test_helper'

class BettingPoolTest < ActiveSupport::TestCase

  test "changing the pool value, updates user balance" do
    pool = betting_pools(:mega_pool)
    dude = user_groups(:dude)
    bob = user_groups(:bob)

    assert_equal 0, pool.value
    assert_equal 0, dude.balance
    assert_equal 10, bob.balance

    pool.join(dude)
    pool.join(bob)

    assert_equal 0, dude.balance
    assert_equal 10, bob.balance

    pool.value = 30
    pool.save!

    assert_equal (-15), dude.balance
    assert_equal (-5), bob.balance

    pool.value = 20
    pool.save!

    assert_equal (-10), dude.balance
    assert_equal 0, bob.balance
  end

  test "changing the pool size, updates user balance" do
    pool = betting_pools(:mega_pool)
    dude = user_groups(:dude)
    bob = user_groups(:bob)

    pool.join(bob)

    pool.value = 30
    pool.save!

    assert_equal (-20), bob.balance
    assert_equal 0,     dude.balance

    pool.join(dude)

    assert_equal (-5),  bob.balance
    assert_equal (-15), dude.balance

    james = UserGroup.create!(user: users(:james), group: groups(:default_group))

    pool.join(james)

    assert_equal 0,     bob.balance
    assert_equal (-10), dude.balance
    assert_equal (-10), james.balance

    pool.leave(dude)
    dude.reload

    assert_equal (-5),  bob.balance
    assert_equal 0,     dude.balance
    assert_equal (-15), james.balance

    pool.leave(bob)
    bob.reload

    assert_equal 10,    bob.balance
    assert_equal 0,     dude.balance
    assert_equal (-30), james.balance

    pool.leave(james)
    james.reload

    assert_equal 10, bob.balance
    assert_equal 0,  dude.balance
    assert_equal 0,  james.balance
  end

end
