defmodule MihainatorWeb.UploadLive do
  @moduledoc false

  use MihainatorWeb, :live_view

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:has_result, false)}
  end

  @impl Phoenix.LiveView
  def handle_info({ref, result}, socket) do
    Process.demonitor(ref, [:flush])

    socket = assign(socket, calendar_dates: result, has_result: true)

    {:noreply, socket}
  end
end
