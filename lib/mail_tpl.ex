defmodule Bday.MailTpl do
  alias Bday.Employee
  def body(employee) do
    name = Employee.first_name(employee)
    "Happy birthday, dear #{name}!"
  end

  def full(employee) do
    {[Employee.email(employee)], "Happy birthday!", body(employee)}
  end
end
