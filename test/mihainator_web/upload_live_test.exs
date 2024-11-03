defmodule MihainatorWeb.UploadLiveTest do
  @moduledoc false

  use MihainatorWeb.ConnCase

  test "calender has markings for interaction days", %{conn: conn} do
    conn
    |> visit("/")
    |> upload("CSV file", "data/test.csv")
    |> click_button("Upload")
    |> assert_has("button.bg-green-300")
    |> assert_has("button.bg-red-300")
  end
end
