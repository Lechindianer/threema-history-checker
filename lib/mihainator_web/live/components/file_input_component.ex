defmodule MihainatorWeb.FileInputComponent do
  @moduledoc false

  use Phoenix.LiveComponent

  @impl true
  def mount(socket) do
    {:ok,
     socket
     |> assign(:submit_disabled?, true)
     |> allow_upload(:history, accept: ~w(.csv))}
  end

  @impl true
  def handle_event("validate", _params, socket) do
    {:noreply,
     socket
     |> assign(:submit_disabled?, false)}
  end

  @impl true
  def handle_event("save", _params, socket) do
    consume_uploaded_entries(socket, :history, fn %{path: path}, _entry ->
      dest =
        System.tmp_dir!()
        |> Path.join(Path.basename(path))

      File.cp!(path, dest)

      Task.async(fn -> Mihainator.Extractor.extract(dest) end)

      {:ok, nil}
    end)

    {:noreply, socket}
  end

  defp error_to_string(:too_large), do: "Too large"
  defp error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
end
