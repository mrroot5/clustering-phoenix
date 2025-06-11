defmodule ClusteringPhoenixWeb.Home.Index do
  use ClusteringPhoenixWeb, :live_view

  require Logger

  @type nodes() :: [node()]

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:node_info, Node.self())
     |> assign(:node_list, get_nodes(Node.list()))
     |> assign(:page_title, "List & Ping Nodes")
     |> assign(:random_ping, "")}
  end

  @impl true
  def handle_event("random_ping", _value, socket) do
    ping_result = random_ping()

    {:noreply, assign(socket, :random_ping, ping_result)}
  end

  @spec do_random_ping(node()) :: String.t()
  defp do_random_ping(node) do
    result =
      node
      |> Node.ping()
      |> Atom.to_string()

    "PING #{node}: #{result}"
  end

  @spec get_nodes(nodes | []) :: nodes
  defp get_nodes(nodes) when nodes == [], do: [Node.self()]

  defp get_nodes(nodes), do: Enum.map(nodes, &Atom.to_string(&1))

  @spec random_ping :: String.t()
  defp random_ping() do
    nodes = Node.list()

    if nodes == [] do
      do_random_ping(Node.self())
    else
      nodes
      |> Enum.random()
      |> do_random_ping()
    end
  end
end
