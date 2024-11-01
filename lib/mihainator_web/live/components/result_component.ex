defmodule MihainatorWeb.ResultComponent do
  @moduledoc false

  use Phoenix.LiveComponent

  @impl true
  def update(assigns, socket) do
    months = get_one_day_for_each_month(assigns.calendar_dates)

    socket = assign(socket, assigns: assigns, months: months)

    {:ok, socket}
  end

  def time_button(assigns) do
    {day, info} = assigns.day

    day = get_date(day)

    {out_messages, in_messages} =
      Enum.split_with(info, fn %{direction: direction} -> direction == "out" end)

    length_out = length(out_messages)
    length_in = length(in_messages)

    state =
      cond do
        length_in < length_out -> "bg-green-300 dark:text-slate-600"
        length_in > length_out -> "bg-red-300 dark:text-slate-600"
        true -> ""
      end

    assigns = assign(assigns, state: state, day: day.day)

    ~H"""
    <button class={@state}>
      <time><%= @day %></time>
    </button>
    """
  end

  def month(assigns) do
    day = get_date(assigns.day)

    formatted_month = day |> Calendar.strftime("%B")

    assigns = assign(assigns, formatted_month: formatted_month, year: day.year)

    ~H"""
    <div class="text-center border-b pb-2 text-slate-700 dark:text-slate-300">
      <div>
        <%= @formatted_month %>
        <span class="font-extrabold"><%= @year %></span>
      </div>
    </div>
    """
  end

  def get_days_of_month(socket, first_of_month) do
    first_of_month = get_date(first_of_month)
    start_of_range = NaiveDateTime.to_date(first_of_month) |> Date.shift(day: -1)
    end_of_range = Date.end_of_month(first_of_month) |> Date.shift(day: 1)

    Map.filter(socket.assigns.calendar_dates, fn {date, _} ->
      date = get_date(date)

      Date.after?(date, start_of_range) and Date.before?(date, end_of_range)
    end)
  end

  defp get_one_day_for_each_month(calendar_dates) do
    Map.keys(calendar_dates)
    |> Enum.sort()
    |> Enum.filter(fn x -> String.ends_with?(x, "-01") end)
  end

  defp get_date(date) do
    Timex.parse!(date, "{YYYY}-{M}-{D}")
  end
end
