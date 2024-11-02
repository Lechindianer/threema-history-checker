defmodule Mihainator.Extractor do
  @moduledoc """
  This module will take Threema's CSV history file and parse dates / interaction patterns per day
  """

  def extract(file) do
    raw_data = get_raw_data(file)

    last_date =
      Enum.at(raw_data, -1).date
      |> Date.end_of_month()

    first_date =
      Date.shift(last_date, year: -1)
      |> Date.beginning_of_month()

    year_date_range = Date.range(first_date, last_date)

    dates_to_check =
      raw_data
      |> Enum.filter(fn %{date: date} -> Date.after?(date, first_date) end)
      |> Enum.group_by(&get_group_key/1)

    Map.new(year_date_range, fn x -> {x, []} end)
    |> get_normalized_interaction_data(dates_to_check)
    |> Map.new()
  end

  defp get_raw_data(file) do
    File.stream!(file)
    |> CSV.decode!(separator: ?,, headers: true, escape_max_lines: 100)
    |> Stream.map(&extract_data/1)
    |> Enum.to_list()
  end

  defp extract_data(%{"isoutbox" => is_out, "posted_at" => posted_at}) do
    is_out =
      case is_out do
        "1" -> "out"
        "0" -> "in"
      end

    date =
      posted_at
      |> String.to_integer()
      |> DateTime.from_unix!(:millisecond)
      |> DateTime.to_date()

    %{date: date, direction: is_out}
  end

  defp get_group_key(%{date: date}) do
    month =
      Integer.to_string(date.month)
      |> String.pad_leading(2, "0")

    day =
      Integer.to_string(date.day)
      |> String.pad_leading(2, "0")

    "#{date.year}-#{month}-#{day}"
  end

  defp get_normalized_interaction_data(date_range, dates_to_check) do
    Enum.map(date_range, fn {date, _} ->
      date = Date.to_string(date)

      if Map.has_key?(dates_to_check, date) do
        {date, Map.get(dates_to_check, date)}
      else
        {date, []}
      end
    end)
  end
end
