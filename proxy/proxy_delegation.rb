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
    @subject = real_object
  end

  def method_missing(name, *args)
    puts "Delegating #{name} message to #{@subject.class}."
    @subject.send(name, *args)
  end
end

require 'etc'

class AccountProtectionProxy
  def initialize(real_account, owner_name)
    @subject = real_account
    @owner_name = owner_name
  end

  def method_missing(name, *args)
    check_access
    puts "Delegating #{name} message to #{@subject.class}."
    @subject.send(name, *args)
  end

  def check_access
    raise "Illegal access: #{Etc.getlogin} cannot access account." if Etc.getlogin != @owner_name
  end
end

#Universal proxy
class VirtualProxy
  def initialize(&creation_block)
    @creation_block = creation_block
  end

  def method_missing(name, *args)
    subject.send(name, *args)
  end

  def subject
    @subject = @creation_block.call unless @subject
    @subject
  end
end

account = BankAccount.new(12456)
account.deposit(12)
account.withdraw(87)

proxy = BankAccountProxy.new(account)
proxy.deposit(78)
proxy.withdraw(7441)

puts "Account balance: #{account.balance}"
puts "Proxy balance: #{proxy.balance}"

protection_1 = AccountProtectionProxy.new(account, "carlos.guisao")
protection_2 = AccountProtectionProxy.new(account, "vaco")
protection_1.withdraw(47)
#protection_2.withdraw(554)

array = VirtualProxy.new { Array.new }
array << "Hello there"
puts array

account_with_virtual_proxy = VirtualProxy.new { BankAccount.new(7854) }
account_with_virtual_proxy.deposit(2146)
puts "Account balance with virtual proxy #{account_with_virtual_proxy.balance}"
