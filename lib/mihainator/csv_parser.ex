defmodule Mihainator.CSVParser do
  @moduledoc false

  def start(file) do
    File.stream!(file)
    |> Stream.map(&String.split(&1, ","))
    |> Enum.count()
  end
end
