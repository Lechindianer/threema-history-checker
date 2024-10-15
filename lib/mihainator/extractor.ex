defmodule Mihainator.Extractor do
  @moduledoc """
  This module will take Threema's CSV history file and parse dates / first interaction of day
  """

  def extract(file) do
    raw_data = get_raw_data(file)

    {last_date, _} = Enum.at(raw_data, -1)
    first_date = Date.shift(last_date, year: -1)
    date_range = Date.range(first_date, last_date)

    interaction_data =
      raw_data
      |> Enum.filter(fn {date, _} -> Date.after?(date, first_date) end)
      |> Map.new()
      |> get_normalized_interaction_data(date_range)

    %{
      first_date: first_date,
      last_date: last_date,
      interaction_data: interaction_data
    }
  end

  defp get_raw_data(file) do
    File.stream!(file)
    |> CSV.decode!(separator: ?,, headers: true, escape_max_lines: 100)
    |> Stream.chunk_every(2, 1, :discard)
    |> Stream.filter(&next_day?/1)
    |> Stream.map(&extract_data/1)
    |> Enum.to_list()
  end

  defp next_day?([%{"posted_at" => current}, %{"posted_at" => next}]) do
    current =
      current
      |> String.to_integer()
      |> DateTime.from_unix!(:millisecond)

    next =
      next
      |> String.to_integer()
      |> DateTime.from_unix!(:millisecond)

    Date.diff(next, current) == 1
  end

  defp extract_data([_, %{"isoutbox" => is_out, "posted_at" => posted_at}]) do
    is_out = is_out == "1"

    posted_at =
      posted_at
      |> String.to_integer()
      |> DateTime.from_unix!(:millisecond)
      |> DateTime.to_date()

    {posted_at, is_out}
  end

  defp get_normalized_interaction_data(date_to_postinfo, date_range) do
    Enum.map(date_range, fn date ->
      if Map.has_key?(date_to_postinfo, date) do
        {date, Map.get(date_to_postinfo, date)}
      else
        {date, nil}
      end
    end)
  end
end
