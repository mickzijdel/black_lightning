require 'csv'
require 'json'
namespace :debt do

  desc 'notifies users who have gone into debt recently or have been in debt for a while'
  #should be run early morning not late at night
  task notify_debtors: :environment do
    debtors = User.in_debt

    new_debtors = debtors - User.in_debt(Date.today - 1) #debtors who weren't in debt yesterday
    new_debtors.each do |user|
      puts "notifying #{user.name} of debt"
      DebtMailer.new_debtor(user).deliver
    end

    #finds long time debtors after notifications have been added for all the new debtors
    long_time_debtors = debtors - Admin::DebtNotification.notified_since(Date.today - 14) #debtors who haven't been notified in the last 2 weeks
    long_time_debtors.each do |user|
      puts "reminding #{user.name} of debt"
      DebtMailer.unrepentant_debtor(user).deliver
    end
  end

  desc 'clears all debt records and notification records'
  task clear_all_debts: :environment do
    Admin::MaintenanceDebt.destroy_all
    Admin::StaffingDebt.destroy_all
    Admin::DebtNotification.destroy_all
    puts "all debt records cleared"
  end

end