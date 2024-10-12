defmodule Mihainator.CSVParser do
  @moduledoc false

  def start(file) do
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

    [is_out, posted_at]
  end
end
