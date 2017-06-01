class BettingPool < ApplicationRecord
  belongs_to :group
  has_many :lottery_bets, dependent: :destroy
  has_many :pool_participations,
    :dependent => :destroy,
    :after_remove => :udpate_on_remove,
    :after_add => :update_on_add

  alias_attribute :bets, :lottery_bets
  alias_attribute :participants, :pool_participations

  after_update :update_values_on_update

  def join(user_group)
    self.pool_participations << PoolParticipation.create(user_group: user_group)
  end

  def leave(user_group)
    part = PoolParticipation.where(user_group: user_group)
    if !part.empty?
      self.participants.delete(part.first)
    end
  end

  protected

  def udpate_on_remove(obj)
    self.recalculate_values(:user_left, obj)
  end

  def update_on_add(obj)
    self.recalculate_values(:user_joined, obj)
  end

  def update_values_on_update
    self.recalculate_values(:pool_value_updated)
  end

  def recalculate_values(action, user_delta = nil)
    old_value = self.attribute_before_last_save('value')
    new_value = self.value

    count = self.participants.size

    old_value_per_participant = self.value_per_participant
    self.value_per_participant = new_value / count

    logger.debug "Pool values > old: #{old_value} new: #{new_value}"
    logger.debug "Pool values p/ participant > old: #{old_value_per_participant} current: #{self.value_per_participant} count: #{count}"

    UserBalanceEntry.transaction do

      if !user_delta.nil? and action == :user_left
        UserBalanceEntry.create!(user_group: user_delta.user_group, value: old_value_per_participant, approved: true, description: "Value update: #{action}")
      end

      self.participants.each do |participant|
        logger.debug "Will update #{participant.user_group.user.name} balance $ #{participant.user_group.balance}, add $ #{old_value_per_participant} rem $ #{- self.value_per_participant}"

        if old_value_per_participant != 0
          if user_delta != participant or action == :user_left
            UserBalanceEntry.create!(user_group: participant.user_group, value: old_value_per_participant, approved: true, description: "Value update: #{action}")
          end
        end

        if self.value_per_participant != 0
          if user_delta != participant or action == :user_joined
            UserBalanceEntry.create!(user_group: participant.user_group, value: - self.value_per_participant, approved: true, description: "Value update: #{action}")
          end
        end

      end

    end

  end

end

