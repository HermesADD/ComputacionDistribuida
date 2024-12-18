defmodule GraphNode do
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

  Inicia el proceso del nodo y devuelve el PID del proceso del nodo.
  """
  def start_node(id, name, neighbors \\ [], leader\\ nil) do
    IO.puts("Se crea un nuevo nodo con ID: #{id}, Nombre: #{name}")
    spawn(fn -> manager(id, name, neighbors, leader) end)
  end

  @doc """
  Gestor del nodo, gestiona la recepción de mensajes y la manipulación de sus vecinos.

  El proceso espera varios tipos de mensajes:

    - `{:message, from_id, msg}`: Recibe un mensaje de otro nodo identificado por `from_id` y muestra el mensaje.
    - `{:add_neighbor, neighbor_pid}`: Añade un nuevo vecino al nodo.
    - `{:send_message, _neighbor_id, msg}`: Envía un mensaje a todos los vecinos del nodo.
    - `:get_neighbors`: Muestra la lista de procesos que son vecinos del nodo.
    - `{:proclaim_leader, from_id}`: Mecanismo de elección de lider
    - Otros mensajes no reconocidos serán capturados y se mostrará un mensaje indicando que no son conocidos.

  ## Parámetros
    - `id`: El identificador único del nodo (ID).
    - `name`: El nombre del nodo.
    - `neighbors`: La lista de procesos vecinos del nodo.
    - `leader`: Indica el lider del nodo, si es que tiene
    - `accepte_leaders`: Nos ayuda a que si el vecino ya recibio al lider, no se vuelve a mostrar otra vez y evitemos repeticiones
  """
  def manager(id, name, neighbors, leader, accepted_leaders \\ MapSet.new()) do
    receive do
      #Recibe un mensaje de un nodo a otro.
      {:message, from_id, msg} ->
        IO.puts("#{name} (ID: #{id}) recibió un mensaje de nodo #{from_id}: #{msg}")
        manager(id, name, neighbors, leader, accepted_leaders)

      #Agrega un vecino al nodo
      {:add_neighbor, neighbor_pid} ->
        manager(id, name, [neighbor_pid | neighbors], leader, accepted_leaders)

      #Envia un mensaje de un nodo a sus vecinos
      {:send_message, _neighbor_id, msg} ->
        Enum.each(neighbors, fn neighbor -> send(neighbor, {:message, id, msg}) end)
        manager(id, name, neighbors, leader, accepted_leaders)

      #Obtiene los vecinos del nodo
      :get_neighbors ->
        IO.puts("Vecinos del nodo #{name} (ID: #{id}): #{inspect(neighbors)}")
        manager(id, name, neighbors, leader, accepted_leaders)

      # Mecanismo de elección de líder
      {:proclaim_leader, from_id} ->
        # Si aún no hemos aceptado a este líder, lo aceptamos y propagamos el mensaje
        if not MapSet.member?(accepted_leaders, from_id) do
          new_accepted_leaders = MapSet.put(accepted_leaders, from_id)

          # Verificamos si el nodo actual acepta a este líder
          if from_id < id or from_id == id do
            IO.puts("#{name} (ID: #{id}) acepta que el nodo con ID #{from_id} es el líder.")
          else
            IO.puts("#{name} (ID: #{id}) no acepta que el nodo con ID #{from_id} sea el líder.")
          end

          # Propagamos el mensaje a los vecinos
          Enum.each(neighbors, fn neighbor -> send(neighbor, {:proclaim_leader, from_id}) end)
          manager(id, name, neighbors, leader, new_accepted_leaders)
        else
          # Si ya lo aceptamos, continuamos sin hacer nada
          manager(id, name, neighbors, leader, accepted_leaders)
        end

      _ ->
        IO.puts("#{name} (ID: #{id}) recibió un mensaje no reconocido.")
        manager(id, name, neighbors, leader)
    end
  end
end

defmodule Graph do
  @moduledoc """
  Módulo para gestiona gráficas. Permite iniciar una gráfica, agregar nodos,
  conectarlos entre sí, y enviar mensajes a través de los nodos.
  """

  @doc """
  Inicializa una nueva gráfica vacía.

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

  Devuelve la gráfica actualizada con el nuevo nodo agregado.
  """
  def add_node(graph, id, name) do
    node_pid = GraphNode.start_node(id, name)
    Map.put(graph, id, node_pid)
  end

  @doc """
  Conecta dos nodos de la gráfica, en este caso la gráfica es no dirigida.

  ## Parámetros
    - `graph`: La gráfica actual.
    - `id1`: El identificador del primer nodo.
    - `id2`: El identificador del segundo nodo.

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

  @doc """
  Envía un mensaje a un nodo dentro de la gráfica para proclamarlo como líder.

  ## Parámetros
    - `graph`: La gráfica actual.
    - `node_id`: El identificador del nodo al que se le enviará el mensaje para proclamarlo como líder.


  Si el nodo con `node_id` existe en el `graph`, se envía un mensaje al proceso asociado al nodo con la
  tupla `{:proclaim_leader, node_id}`. Si el nodo no se encuentra en el `graph`, se imprime un mensaje
  indicando que no se encontró el nodo con ese `node_id`.
  """
  def proclaim_leader(graph, node_id) do
    pid = Map.get(graph, node_id)
    if pid do
      send(pid, {:proclaim_leader, node_id})
    else
      IO.puts("Nodo con ID: #{node_id} no encontrado.")
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

#Nodo v
Graph.proclaim_leader(graph,22)
#Nodo t
Graph.proclaim_leader(graph,20)
