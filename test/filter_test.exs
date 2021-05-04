defmodule FilterTest do
  use ExUnit.Case

  doctest Bdaykata

  test "property-style filtering test" do
    years = generate_years_data(2021, 2041)
    people = generate_people_for_year(3)

    for yeardata <- years do
      birthdays = find_birthdays_for_year(people, yeardata)
      every_birthday_once(people, birthdays)
      on_right_date(people, birthdays)
    end
  end

  defp find_birthdays_for_year(_, []), do: []
  defp find_birthdays_for_year(people, [day | year]) do
    found = Filter.birthday(people, day)
    [{day, found} | find_birthdays_for_year(people, year)]
  end
end
