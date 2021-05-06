defmodule Employee do
  if Mix.env() == :test do
    def adapt_csv_result_shim(map), do: adapt_csv_result(map)
  end

  @spec last_name(employee()) :: String.t() | nil
  def last_name(%{"last_name" => name}), do: name

  @spec first_name(employee()) :: String.t() | nil
  def first_name(%{"first_name" => name}), do: name

  @spec date_of_birth(employee()) :: String.t()
  def date_of_birth(%{"date_of_birth" => email}), do: email

  @spec email(employee()) :: String.t() | nil
  def email(%{"email" => name}), do: name

  @opaque employee() :: %{required(String.t()) => term()}
  @opaque handle() :: {:raw, [employee()]}
  def from_csv(string) do
    {:raw,
     for map <- Csv.decode(string) do
       adapt_csv_result(map)
     end}
  end

  @spec fetch(handle()) :: [employee()]
  def fetch({:raw, maps}), do: maps

  @spec filter_birthday(handle(), Date.t()) :: handle()
  def filter_birthday({:raw, employees}, date) do
    {:raw, Filter.birthday(employees, date)}
  end

  defp adapt_csv_result(map) do
    map =
      for {k, v} <- map, into: %{} do
        {trim(k), maybe_null(trim(v))}
      end

    dob = Map.fetch!(map, "date_of_birth")
    %{map | "date_of_birth" => parse_date(dob)}
  end

  defp trim(str), do: String.trim_leading(str, " ")

  defp maybe_null(""), do: nil
  defp maybe_null(str), do: str

  defp parse_date(str) do
    [y, m, d] = Enum.map(String.split(str, "/"), &String.to_integer(&1))
    {:ok, date} = Date.new(y, m, d)
    date
  end
end
