class UserBalanceEntry < ApplicationRecord
  belongs_to :user_group, dependent: :destroy
  after_create :update_balance_on_creation
  after_update :update_balance_on_update

  private

  def update_balance_on_creation
    if self.approved?
      self.user_group.balance += self.value
      self.user_group.save!
    end
  end

  def update_balance_on_update
    #if self.approved_was
    if self.attribute_before_last_save('approved')
      raise "Balance can't be updated after approved"
    elsif self.approved?
      curr_balance = self.user_group.balance
      self.user_group.balance = curr_balance + self.value
      self.user_group.save!
    end
  end

end
