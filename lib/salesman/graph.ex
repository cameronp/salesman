defmodule Salesman.Graph do
  alias Salesman.Graph
  alias Salesman.Graph.Node

  defmodule Node do
    defstruct x: 0, y: 0, visited: false
    def create(x, y), do: %Node{x: x, y: y}
  end

  @spec distance(Salesman.Graph.Node.t(), Salesman.Graph.Node.t()) :: float
  def distance(%Node{x: x, y: y}, %Node{x: x1, y: y1}),
    do: :math.sqrt(:math.pow(x - x1, 2) + :math.pow(y - y1, 2))

  defstruct nodes: []

  def insert(%Graph{nodes: nodes}, x, y), do: %Graph{nodes: [%Node{x: x, y: y} | nodes]}
  def insert(%Graph{nodes: nodes}, %Node{} = n), do: %Graph{nodes: [n | nodes]}

  def neighbors(%Graph{nodes: nodes}, node), do: nodes -- [node]

  def unvisited_neighbors(graph, node),
    do: neighbors(graph, node) |> Enum.filter(fn %Node{visited: v} -> !v end)

  def unvisited_neighbors_with_distance(graph, node),
    do:
      unvisited_neighbors(graph, node)
      |> Enum.map(fn neighbor -> {neighbor, distance(node, neighbor)} end)

  def nearest_neighbor(graph, node) do
    case unvisited_neighbors_with_distance(graph, node) do
      [] -> nil
      neighbors -> Enum.sort_by(neighbors, fn {_, d} -> d end) |> hd() |> elem(0)
    end
  end

  def visit(node = %Node{visited: false}), do: Map.put(node, :visited, true)

  def visit(%Graph{nodes: nodes}, node) do
    %Graph{nodes: (nodes -- [node]) ++ [visit(node)]}
  end

  def tour(graph, start), do: tour(graph, start, [])

  defp tour(graph, start, result) do
    case nearest_neighbor(graph, start) do
      nil ->
        Enum.reverse([start | result])

      next ->
        new_graph = visit(graph, start)
        tour(new_graph, next, [start | result])
    end
  end
end
