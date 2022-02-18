# frozen_string_literal: true

class ResetDb
  # rubocop:disable Metrics/MethodLength
  def self.call(force: false)
    if force
      Transaction.destroy_all
      Payee.destroy_all
      Account::Base.destroy_all
    else
      starting_payees = { name: ['Starting balance', 'Saldo inicial'] }
      Transaction.where(payee_id: nil).destroy_all
      Transaction.joins(:payee).where.not(payees: starting_payees).destroy_all
      Payee.where.not(starting_payees).destroy_all
    end

    MonthlyBudget.destroy_all
    Month.destroy_all
  end
  # rubocop:enable Metrics/MethodLength
end
