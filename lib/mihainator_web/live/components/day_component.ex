defmodule MihainatorWeb.DayComponent do
  @moduledoc false

  use Phoenix.LiveComponent

  @impl true
  def render(assigns) do
    ~H"""
    <button class={@classes} style={@style}>
      <time><%= @day %></time>
    </button>
    """
  end

  @impl true
  def update(assigns, socket) do
    {day, info} = assigns.day
    parsed_day = get_date(day)

    classes = get_button_classes(info)
    style = get_button_style(day)

    socket = assign(socket, classes: classes, day: parsed_day.day, style: style)

    {:ok, socket}
  end

  defp get_button_classes(info) do
    {out_messages, in_messages} =
      Enum.split_with(info, fn %{direction: direction} -> direction == "out" end)

    length_out = length(out_messages)
    length_in = length(in_messages)

    cond do
      length_in < length_out -> "bg-green-300 dark:text-slate-600"
      length_in > length_out -> "bg-red-300 dark:text-slate-600"
      true -> ""
    end
  end

  defp get_button_style(day) do
    is_first_of_month = String.ends_with?(day, "-01")

    day = get_date(day)

    case is_first_of_month do
      true -> "grid-column: #{Date.day_of_week(day)}"
      _ -> ""
    end
  end

  defp get_date(date) do
    Timex.parse!(date, "{YYYY}-{M}-{D}")
  end
end
