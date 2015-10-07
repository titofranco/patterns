class Employee
  attr_reader :name, :title, :salary
  def initialize(name, title, salary)
    @name = name
    @title = title
    @salary = salary
    @observers = []
  end

  def salary=(new_salary)
    @salary = new_salary
    notify_observers
  end

  def add_observer(observer)
    @observers << observer
  end

  def delete_observer(observer)
    @observers.delete(observer)
  end

  def notify_observers
    @observers.each do |observer|
      observer.update(self)
    end
  end

end


class Payroll
  def update(changed_employee)
    puts "Cut a new check for #{changed_employee.name}"
    puts "His salary is now #{changed_employee.salary}"
  end
end

class TaxMan
  def update(changed_employee)
    puts "Send #{changed_employee.name} a new tax bill!"
  end
end

payroll = Payroll.new
tax_man = TaxMan.new

carlos = Employee.new('Carlos', 'Ruby Dev', 5000)
carlos.add_observer(payroll)
carlos.add_observer(tax_man)

carlos.salary = 55000
