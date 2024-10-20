defmodule MihainatorWeb.ResultComponent do
  @moduledoc false

  use Phoenix.LiveComponent

  @impl true
  def update(assigns, socket) do
    socket = assign(socket, assigns)

    months = get_months(assigns.calendar_dates)

    socket = assign(socket, months: months)

    {:ok, socket}
  end

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  def time_button(assigns) do
    ~H"""
    <button>
      <time><%= @day %></time>
    </button>
    """
  end

  defp get_months(%{first_date: first_date}) do
    start = Date.beginning_of_month(first_date)

    for month_difference <- 0..11, do: Date.shift(start, month: month_difference)
  end
end
