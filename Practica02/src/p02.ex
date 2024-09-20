defmodule Node do
  @moduledoc """
  Modulo con las funciones de la Node, representa un nodo en una gráfica
  además de sus funciones que se pueden realizar con cada uno.
  """

  @doc """
  Inicia un nuevo nodo en la gráfica

  ## Parámetros
    - `id`: El identificador único del nodo(ID)
    - `name`: El nombre del nodo
    - `neighbors`: una lista opcional de vecinos, que por defecto está vacía.

  ## Ejemplo
    iex> pid = Node.start_node(1, "Nodo1")
    Se crea un nuevo nodo con ID: 1, Nombre: Nodo1
    #PID<0.120.0>

  Inicia el proceso del nodo y devuelve el PID del proceso del nodo.
  """
  def start_node(id, name, neighbors \\ []) do
    IO.puts("Se crea un nuevo nodo con ID: #{id}, Nombre: #{name}")
    spawn(fn -> node_loop(id, name, neighbors) end)
  end

  @doc """
  Bucle principal del nodo, que gestiona la recepción de mensajes y la manipulación de sus vecinos.

  El proceso espera varios tipos de mensajes:

    - `{:message, from_id, msg}`: Recibe un mensaje de otro nodo identificado por `from_id` y muestra el mensaje.
    - `{:add_neighbor, neighbor_pid}`: Añade un nuevo vecino al nodo.
    - `{:send_message, _neighbor_id, msg}`: Envía un mensaje a todos los vecinos del nodo.
    - `:get_neighbors`: Muestra la lista de procesos que son vecinos del nodo.
    - Otros mensajes no reconocidos serán capturados y se mostrará un mensaje indicando que no son conocidos.

  ## Parámetros
    - `id`: El identificador único del nodo (ID).
    - `name`: El nombre del nodo.
    - `neighbors`: La lista de procesos vecinos del nodo.

  ## Ejemplo
    iex> send(pid, {:message, 2, "Hola"})
    Nodo1 (ID: 1) recibió un mensaje de nodo 2: Hola

    iex> send(pid, {:add_neighbor, neighbor_pid})
    iex> send(pid, :get_neighbors)
    Vecinos del nodo Nodo1 (ID: 1): [#PID<0.121.0>]

  El bucle continúa recibiendo mensajes y actualizando el estado del nodo.
  """
  defp node_loop(id, name, neighbors) do
    receive do
      {:message, from_id, msg} ->
        IO.puts("#{name} (ID: #{id}) recibió un mensaje de nodo #{from_id}: #{msg}")
        node_loop(id, name, neighbors)

      {:add_neighbor, neighbor_pid} ->
        node_loop(id, name, [neighbor_pid | neighbors])

      {:send_message, _neighbor_id, msg} ->
        Enum.each(neighbors, fn neighbor_pid ->
          send(neighbor_pid, {:message, id, msg})
        end)
        node_loop(id, name, neighbors)

      :get_neighbors ->
        IO.puts("Vecinos del nodo #{name} (ID: #{id}): #{inspect(neighbors)}")
        node_loop(id, name, neighbors)

      _ ->
        IO.puts("#{name} (ID: #{id}) recibió un mensaje desconocido.")
        node_loop(id, name, neighbors)
    end
  end
end

defmodule Graph do
  @doc """
  Módulo para gestiona gráficas. Permite iniciar una gráfica, agregar nodos,
  conectarlos entre sí, y enviar mensajes a través de los nodos.
  """

  @doc """
  Inicializa una nueva gráfica vacía.

  ## Ejemplo

    iex> graph = Graph.start_graph()
    %{}

  Devuelve un mapa vacío que representa la gráfica.
  """
  def start_graph() do
    %{}
  end

  @doc """
  Agrega un nodo a la gráfica.

  ## Parámetros
    - `graph`: La gráfica actual, representada como un mapa.
    - `id`: El identificador único del nodo.
    - `name`: El nombre del nodo.

  ## Ejemplo
    iex> graph = Graph.start_graph()
    iex> graph = Graph.add_node(graph, 1, "Nodo1")
    Se crea un nuevo nodo con ID: 1, Nombre: Nodo1
    %{1 => #PID<0.121.0>}

  Devuelve la gráfica actualizada con el nuevo nodo agregado.
  """
  def add_node(graph, id, name) do
    node_pid = Node.start_node(id, name)
    Map.put(graph, id, node_pid)
  end

  @doc """
  Conecta dos nodos de la gráfica (gráfica no dirigido).

  ## Parámetros
    - `graph`: La gráfica actual.
    - `id1`: El identificador del primer nodo.
    - `id2`: El identificador del segundo nodo.

  ## Ejemplo
    iex> graph = Graph.add_node(%{}, 1, "Nodo1")
    iex> graph = Graph.add_node(graph, 2, "Nodo2")
    iex> Graph.connect_nodes(graph, 1, 2)
    Nodos 1 y 2 conectados.

  Envía mensajes a ambos nodos para que se añadan como vecinos mutuamente.
  Si uno o ambos nodos no existen, muestra un mensaje de error.
  """
  def connect_nodes(graph, id1, id2) do
    pid1 = Map.get(graph, id1)
    pid2 = Map.get(graph, id2)

    if pid1 && pid2 do
      send(pid1, {:add_neighbor, pid2})
      send(pid2, {:add_neighbor, pid1})
      IO.puts("Nodos #{id1} y #{id2} conectados.")
    else
      IO.puts("Uno o ambos nodos no existen.")
    end

    graph
  end

  @doc """
  Envía un mensaje desde un nodo específico a sus vecinos.

  ## Parámetros
    - `graph`: La gráfica actual.
    - `from_id`: El identificador del nodo desde el cual se enviará el mensaje.
    - `msg`: El mensaje que será enviado.

  ## Ejemplo
      iex> graph = Graph.add_node(%{}, 1, "Nodo1")
      iex> graph = Graph.add_node(graph, 2, "Nodo2")
      iex> Graph.connect_nodes(graph, 1, 2)
      iex> Graph.send_message(graph, 1, "Hola vecinos")
      Nodo1 (ID: 1) recibió un mensaje de nodo 1: Hola vecinos

  Envía un mensaje desde el nodo identificado por `from_id` a todos sus vecinos.
  Si el nodo no existe, muestra un mensaje de error.
  """
  def send_message(graph, from_id, msg) do
    pid = Map.get(graph, from_id)
    if pid do
      send(pid, {:send_message, from_id, msg})
    else
      IO.puts("Nodo con ID: #{from_id} no encontrado.")
    end
  end
end

# Crear una gráfica
graph = Graph.start_graph()

# Agregar nodos
graph = Graph.add_node(graph, 22, "Nodo v")
graph = Graph.add_node(graph, 20, "Nodo t")
graph = Graph.add_node(graph, 24, "Nodo x")
graph = Graph.add_node(graph, 25, "Nodo y")
graph = Graph.add_node(graph, 26, "Nodo z")
graph = Graph.add_node(graph, 21, "Nodo u")
graph = Graph.add_node(graph, 23, "Nodo w")
graph = Graph.add_node(graph, 19, "Nodo s")
graph = Graph.add_node(graph, 18, "Nodo r")
graph = Graph.add_node(graph, 17, "Nodo q")


# Conectar nodos
graph = Graph.connect_nodes(graph, 22, 24)
graph = Graph.connect_nodes(graph, 24, 20)
graph = Graph.connect_nodes(graph, 24, 23)
graph = Graph.connect_nodes(graph, 20, 23)
graph = Graph.connect_nodes(graph, 25, 24)
graph = Graph.connect_nodes(graph, 25, 26)
graph = Graph.connect_nodes(graph, 25, 21)
graph = Graph.connect_nodes(graph, 19, 17)
graph = Graph.connect_nodes(graph, 18, 19)

# Enviar un mensaje desde un nodo
Graph.send_message(graph, 22, "Hola desde Nodo v")
Graph.send_message(graph, 24, "Hola desde Nodo x")
Graph.send_message(graph, 19, "Hola desde Nodo s")
