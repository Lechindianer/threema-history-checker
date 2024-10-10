defmodule MihainatorWeb.UploadLive do
  use MihainatorWeb, :live_view

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:submit_disabled?, true)
     |> allow_upload(:history, accept: ~w(.csv))}
  end

  @impl Phoenix.LiveView
  def handle_event("validate", _params, socket) do
    {:noreply,
     socket
     |> assign(:submit_disabled?, false)}
  end

  @impl Phoenix.LiveView
  def handle_event("save", _params, socket) do
    consume_uploaded_entries(socket, :history, fn %{path: path}, _entry ->
      Task.async(fn -> Mihainator.CSVParser.start(path) end)

      {:ok, nil}
    end)

    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  @spec handle_info({reference(), any()}, any()) :: {:noreply, any()}
  def handle_info({ref, _result}, socket) do
    Process.demonitor(ref, [:flush])

    {:noreply, socket}
  end

  defp error_to_string(:too_large), do: "Too large"
  defp error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
end
