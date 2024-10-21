defmodule MihainatorWeb.ResultComponent do
  @moduledoc false

  use Phoenix.LiveComponent

  @impl true
  def update(assigns, socket) do
    socket = assign(socket, assigns)

    {:ok, socket}
  end

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  def time_button(assigns) do
    {day, outgoing} = assigns.day

    state =
      case outgoing do
        true -> "bg-green-300"
        false -> "bg-red-300"
        _ -> ""
      end

    assigns = assign(assigns, state: state, day: day.day)

    ~H"""
    <button class={@state}>
      <time><%= @day %></time>
    </button>
    """
  end

  def month(assigns) do
    days_of_month = assigns.days_of_month

    day =
      Enum.at(days_of_month, 0)
      |> elem(0)

    formatted_month = Calendar.strftime(day, "%B")

    assigns = assign(assigns, formatted_month: formatted_month, year: day.year)

    ~H"""
    <div class="month">
      <div>
        <%= @formatted_month %>
        <span class="year"><%= @year %></span>
      </div>
    </div>
    """
  end
end
