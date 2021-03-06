defmodule CsvTest do
  use ExUnit.Case
  use PropCheck
  alias Bday.Csv

  property "roundtrip encoding/decoding", [:verbose] do
    forall maps <- csv_source() do
      maps == Csv.decode(Csv.encode(maps))
    end
  end

  ## Unit Tests ##
  test "one column CSV files are inherently ambiguous" do
    assert "\n\n" == Csv.encode([%{"" => ""}, %{"" => ""}])
    assert [%{"" => ""}] = Csv.decode("\n\n")
  end


  test "one record per line" do
    assert [%{"aaa" => "zzz", "bbb" => "yyy", "ccc" => "xxx"}] ==
    Csv.decode("aaa,bbb,ccc\nzzz,yyy,xxx\n")
  end

  test "optional trailing CRLF" do
    assert [%{"aaa" => "zzz", "bbb" => "yyy", "ccc" => "xxx"}] ==
    Csv.decode("aaa,bbb,ccc\nzzz,yyy,xxx")
  end

  test "double quotes" do
    assert [%{"aaa" => "zzz", "bbb" => "yyy", "ccc" => "xxx"}] ==
    Csv.decode("\"aaa\",\"bbb\",\"ccc\"\nzzz,yyy,xxx")
  end

  test "escape CRLF" do
    assert [%{"aaa" => "zzz", "b\nbb" => "yyy", "ccc" => "xxx"}] ==
    Csv.decode("\"aaa\",\"b\nbb\",\"ccc\"\nzzz,yyy,xxx")
  end

  test "double quote escaping" do
    # Since we decided headers are mandatory, this test adds a line
    # with empty values (CLRF,,) to the example from the RFC.
    assert [%{"aaa" => "", "b\"bb" => "", "ccc" => ""}] ==
      Csv.decode("\"aaa\",\"b\"\"bb\",\"ccc\"\n,,")
  end

  # this counterexample is taken literally from the RFC and # cannot work with the current implementation because maps # do not allow duplicate keys
  test "dupe keys unsupported" do
    csv =
      "field_name,field_name,field_name\n" <>
        "aaa,bbb,ccc\n" <> "zzz,yyy,xxx\n"

    [map1, map2] = Csv.decode(csv)
    assert ["field_name"] == Map.keys(map1)
    assert ["field_name"] == Map.keys(map2)
  end

  def csv_source() do
    let size <- pos_integer() do
      let keys <- header(size + 1) do
        list(entry(size + 1, keys))
      end
    end
  end

  def entry(size, keys) do
    let vals <- record(size) do
      Map.new(Enum.zip(keys, vals))
    end
  end

  def header(size) do
    vector(size, name())
  end

  def record(size) do
    vector(size, field())
  end

  def name() do
    field()
  end

  def field() do
    oneof([unquoted_text(), quotable_text()])
  end

  def unquoted_text() do
    let chars <- list(elements(textdata())) do
      to_string(chars)
    end
  end

  def quotable_text() do
    let chars <- list(elements('\n' ++ textdata())) do
      to_string(chars)
    end
  end

  def textdata() do
    'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789' ++
    ':;<=>?@ !#$%&\'()*+-./[\\]^_`{|}~'
  end
end
