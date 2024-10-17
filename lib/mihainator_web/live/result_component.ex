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
end
