defmodule Mihainator.ExtractorTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias Mihainator.Extractor

  @test_file Path.join([File.cwd!(), "data", "test.csv"])

  setup_all do
    result = Extractor.extract(@test_file)

    {:ok, result: result}
  end

  test "should have a full year's list of days PLUS a month", state do
    assert Enum.count(state[:result]) == 365 + 31
  end

  test "should subsequent list of days", state do
    sorted_map_keys =
      Map.keys(state[:result])
      |> Enum.sort()

    first_entry = Enum.at(sorted_map_keys, 0) |> Timex.parse!("{YYYY}-{0M}-{0D}")
    second_entry = Enum.at(sorted_map_keys, 1) |> Timex.parse!("{YYYY}-{0M}-{0D}")

    assert NaiveDateTime.shift(first_entry, day: 1) == second_entry
  end

  test "should find communication messages per day", state do
    expected = [
      {"2024-07-07",
       [
         %{date: ~D[2024-07-07], direction: "in"},
         %{date: ~D[2024-07-07], direction: "in"},
         %{date: ~D[2024-07-07], direction: "out"}
       ]},
      {"2024-07-09", [%{date: ~D[2024-07-09], direction: "in"}]},
      {"2024-07-10", [%{date: ~D[2024-07-10], direction: "in"}]},
      {"2024-09-09",
       [%{date: ~D[2024-09-09], direction: "out"}, %{date: ~D[2024-09-09], direction: "out"}]},
      {"2024-09-10",
       [%{date: ~D[2024-09-10], direction: "out"}, %{date: ~D[2024-09-10], direction: "out"}]},
      {"2024-09-11",
       [%{date: ~D[2024-09-11], direction: "in"}, %{date: ~D[2024-09-11], direction: "in"}]},
      {"2024-09-13",
       [%{date: ~D[2024-09-13], direction: "in"}, %{date: ~D[2024-09-13], direction: "in"}]}
    ]

    found_values =
      state[:result]
      |> Enum.filter(fn {_key, value} -> Enum.count(value) > 0 end)
      |> Enum.sort()

    assert found_values == expected
  end
end
