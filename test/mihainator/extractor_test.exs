defmodule Mihainator.ExtractorTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias Mihainator.Extractor

  @test_file Path.join([File.cwd!(), "data", "test.csv"])

  test "should get a full year of sorted months" do
    expected = [
      "2021-12",
      "2022-01",
      "2022-02",
      "2022-03",
      "2022-04",
      "2022-05",
      "2022-06",
      "2022-07",
      "2022-08",
      "2022-09",
      "2022-10",
      "2022-11",
      "2022-12"
    ]

    result = Extractor.extract(@test_file)

    assert Map.keys(result) == expected
  end
end
