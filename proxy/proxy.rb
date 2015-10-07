class BankAccount
 attr_reader :balance

  def initialize(starting_balance=0)
    @balance = starting_balance
  end

  def deposit(amount)
    @balance += amount
  end

  def withdraw(amount)
    @balance -= amount
  end
end


class BankAccountProxy
  def initialize(real_object)
    @real_object = real_object
  end

  def balance
    @real_object.balance
  end

  def deposit(amount)
    @real_object.deposit(amount)
  end

  def withdraw(amount)
    @real_object.withdraw(amount)
  end
end

require 'etc'

class AccountProtectionProxy
  def initialize(real_account, owner_name)
    @subject = real_account
    @owner_name = owner_name
  end

  def deposit(amount)
    check_access
    @subject.deposit(amount)
  end

  def withdraw(amount)
    check_access
    @subject.deposit(amount)
  end

  def balance
    check_access
    @subject.balance
  end

  def check_access
    raise "Illegal access: #{Etc.getlogin} cannot access account." if Etc.getlogin != @owner_name
  end
end


account = BankAccount.new(12456)
account.deposit(12)
account.withdraw(87)

proxy = BankAccountProxy.new(account)
proxy.deposit(78)
proxy.withdraw(7441)

puts account.balance
puts proxy.balance

protection_1 = AccountProtectionProxy.new(account, "carlos.guisao.franco")
protection_2 = AccountProtectionProxy.new(account, "vaco")
protection_1.withdraw(47)
