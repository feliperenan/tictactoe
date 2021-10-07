defmodule TictactoeWeb.Components.Base do
  use Phoenix.Component

  import Phoenix.HTML.Form

  def button(assigns) do
    default_classes = "border px-4 py-2 border-blue-500 bg-blue-700 text-blue-100"

    assigns =
      assigns
      |> set_css_classes(default_classes)
      |> assign_new(:type, fn -> "button" end)
      |> assign_new(:click, fn -> nil end)

    ~H"""
    <%= if @click do %>
      <button type={@type} class={@class} phx-click={@click}>
        <%= render_block(@inner_block) %>
      </button>
    <% else %>
      <button type={@type} class={@class}>
        <%= render_block(@inner_block) %>
      </button>
    <% end %>
    """
  end

  def input(assigns) do
    default_classes = "w-full border-b border-gray-300"

    assigns =
      assigns
      |> set_css_classes(default_classes)
      |> assign_new(:placeholder, fn -> nil end)

    ~H"""
    <%= text_input @f, @name, placeholder: @placeholder, autofocus: true, class: @class %>
    """
  end

  # This is going to combine the CSS classes that might be given when using one of the components
  # above. In case a CSS class is not given it will just use the default one.
  defp set_css_classes(assigns, default) do
    assigns
    |> assign_new(:class, fn -> "" end)
    |> update(:class, fn classes -> default <> " " <> classes end)
  end
end
