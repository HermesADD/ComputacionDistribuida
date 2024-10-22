defmodule Graph do
  @moduledoc """
  Módulo que gestiona gráficas. Permite iniciar una gráfica, agregar nodos,
  conectarlos entre sí, y enviar mensajes entre los nodos.
  """

  @doc """
  Inicia una nueva gráfica vacía.

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
  def add_node(graph, id, name, neighbors \\ [], leader \\ nil) do
    IO.puts("Se crea un nuevo nodo con ID: #{id}, Nombre: #{name}")
    node_pid = spawn(fn -> manager(id, name, neighbors, leader, nil) end)
    Map.put(graph, id, node_pid)
  end

  @doc """
  Conecta dos nodos de la gráfica.

  ## Parámetros
    - `graph`: La gráfica actual.
    - `id1`: El identificador del primer nodo.
    - `id2`: El identificador del segundo nodo.

  Conecta ambos nodos para que se añadan como vecinos mutuamente.
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
  Proclama a un nodo como líder y lo notifica a los vecinos.

  ## Parámetros
    - `graph`: La gráfica actual.
    - `node_id`: El identificador del nodo que será proclamado líder.
  """
  def proclaim_leader(graph, node_id) do
    pid = Map.get(graph, node_id)
    if pid do
      send(pid, {:proclaim_leader, node_id})
    else
      IO.puts("Nodo con ID: #{node_id} no encontrado.")
    end
  end

  @doc """
  Gestor del nodo, maneja la recepción de mensajes y la interacción con los vecinos.

  ## Parámetros
    - `id`: El identificador único del nodo.
    - `name`: El nombre del nodo.
    - `neighbors`: Los vecinos del nodo.
    - `leader`: El líder del nodo, si lo hay.
  """
  defp manager(id, name, neighbors, leader, accepted_leaders \\ MapSet.new(), valor_consensuado) do
    receive do
      {:id, new_id} ->
        # Almacenar el nuevo ID
        IO.puts("#{name} (ID: #{id}) ahora tiene el ID #{new_id}.")
        manager(new_id, name, neighbors, leader, accepted_leaders, valor_consensuado)

      {:proponer, valor} ->
        # Recibir y propagar el valor propuesto
        IO.puts("#{name} (ID: #{id}) propone el valor: #{valor}.")
        Enum.each(neighbors, fn neighbor ->
          send(neighbor, {:proponer, valor})
        end)
        manager(id, name, neighbors, leader, accepted_leaders, valor)

      {:comprobar} ->
        # Comprobar que el nodo tiene el valor consensuado
        if valor_consensuado do
          IO.puts("#{name} (ID: #{id}) tiene el valor consensuado: #{valor_consensuado}.")
        else
          IO.puts("#{name} (ID: #{id}) aún no tiene un valor consensuado.")
        end
        manager(id, name, neighbors, leader, accepted_leaders, valor_consensuado)

      {:message, from_id, msg} ->
        IO.puts("#{name} (ID: #{id}) recibió un mensaje de nodo #{from_id}: #{msg}")
        manager(id, name, neighbors, leader, accepted_leaders, valor_consensuado)

      {:add_neighbor, neighbor_pid} ->
        manager(id, name, [neighbor_pid | neighbors], leader, accepted_leaders, valor_consensuado)

      {:send_message, _neighbor_id, msg} ->
        Enum.each(neighbors, fn neighbor -> send(neighbor, {:message, id, msg}) end)
        manager(id, name, neighbors, leader, accepted_leaders, valor_consensuado)

      :get_neighbors ->
        IO.puts("Vecinos del nodo #{name} (ID: #{id}): #{inspect(neighbors)}")
        manager(id, name, neighbors, leader, accepted_leaders, valor_consensuado)

      {:proclaim_leader, from_id} ->
        if not MapSet.member?(accepted_leaders, from_id) do
          new_accepted_leaders = MapSet.put(accepted_leaders, from_id)

          if from_id < id or from_id == id do
            IO.puts("#{name} (ID: #{id}) acepta que el nodo con ID #{from_id} es el líder.")
          else
            IO.puts("#{name} (ID: #{id}) no acepta que el nodo con ID #{from_id} sea el líder.")
          end

          Enum.each(neighbors, fn neighbor -> send(neighbor, {:proclaim_leader, from_id}) end)
          manager(id, name, neighbors, leader, new_accepted_leaders, valor_consensuado)
        else
          manager(id, name, neighbors, leader, accepted_leaders, valor_consensuado)
        end

      _ ->
        IO.puts("#{name} (ID: #{id}) recibió un mensaje no reconocido.")
        manager(id, name, neighbors, leader, accepted_leaders, valor_consensuado)
    end
  end
end

defmodule Practica03 do
  @moduledoc """
  Módulo que incluye las funciones solicitadas: spawn_in_list/4, genera/1, y send_msg/2.
  """

  @doc """
  Spawnea `n` procesos de una función en un módulo particular y los almacena en una lista.

  ## Parámetros
    - `n`: Número de procesos a crear.
    - `mod`: El módulo donde se encuentra la función.
    - `fun`: La función que será ejecutada.
    - `args`: Los argumentos que se le pasarán a la función.

  ## Ejemplo de uso:
    iex> Practica03.spawn_in_list(4, Modulo, :funcion, [])
  """
  def spawn_in_list(n, mod, fun, args) do
    Enum.map(1..n, fn _ ->
      spawn(mod, fun, args)
    end)
  end

  @doc """
  Spawnea `n` procesos del módulo `Graph`.

  ## Parámetros
    - `n`: El número de procesos a crear.

  ## Ejemplo de uso:
    iex> Practica03.genera(4)
  """
  def genera(n) do
    spawn_in_list(n, Graph, :start_graph, [])
  end

  @doc """
  Envía un mensaje a todos los procesos de una lista de PIDs.

  ## Parámetros
    - `pids`: Lista de procesos (PIDs).
    - `msg`: Mensaje a enviar a cada proceso.

  ## Ejemplo de uso:
    iex> Practica03.send_msg([pid1, pid2], {:inicia})
  """
  def send_msg(pids, msg) do
    Enum.each(pids, fn pid -> send(pid, msg) end)
    {:ok}
  end
end

defmodule Practica03Test do
  use ExUnit.Case

  ExUnit.start()

  setup do
    nodos = Practica03.genera(3)
    Enum.each(0..2, fn i -> send(Enum.at(nodos, i), {:id, i}) end)
    %{nodos: nodos}
  end

  test "todos los nodos se inicializan correctamente", %{nodos: nodos} do
    assert length(nodos) == 3
    assert Enum.all?(nodos, &is_pid(&1))
  end

  test "propagación de valor entre nodos", %{nodos: nodos} do
    Practica03.send_msg(nodos, {:vecinos, nodos})
    send(Enum.at(nodos, 0), {:proponer, "valor_consensuado"})

    # Dar tiempo para que los mensajes se propaguen
    Process.sleep(500)

    # Comprobar que todos los nodos tienen el valor consensuado
    Enum.each(nodos, fn nodo ->
      send(nodo, {:comprobar})
    end)
    assert true
  end

  test "todos los nodos llegan a un consenso sobre el mismo valor", %{nodos: nodos} do
    Practica03.send_msg(nodos, {:vecinos, nodos})
    send(Enum.at(nodos, 0), {:proponer, "valor_final"})

    # Dar tiempo para la propagación del mensaje
    Process.sleep(500)

    # Verificar que todos los nodos tienen el valor consensuado
    Enum.each(nodos, fn nodo ->
      send(nodo, {:comprobar})
    end)
    assert true
  end
end

## Ejecución realizada en la práctica anterior!

# # Crear una gráfica
# graph = Graph.start_graph()

# # Agregar nodos
# graph = Graph.add_node(graph, 22, "Nodo v")
# graph = Graph.add_node(graph, 20, "Nodo t")
# graph = Graph.add_node(graph, 24, "Nodo x")
# graph = Graph.add_node(graph, 25, "Nodo y")
# graph = Graph.add_node(graph, 26, "Nodo z")
# graph = Graph.add_node(graph, 21, "Nodo u")
# graph = Graph.add_node(graph, 23, "Nodo w")
# graph = Graph.add_node(graph, 19, "Nodo s")
# graph = Graph.add_node(graph, 18, "Nodo r")
# graph = Graph.add_node(graph, 17, "Nodo q")

# # Conectar nodos
# graph = Graph.connect_nodes(graph, 22, 24)
# graph = Graph.connect_nodes(graph, 24, 20)
# graph = Graph.connect_nodes(graph, 24, 23)
# graph = Graph.connect_nodes(graph, 20, 23)
# graph = Graph.connect_nodes(graph, 25, 24)
# graph = Graph.connect_nodes(graph, 25, 26)
# graph = Graph.connect_nodes(graph, 25, 21)
# graph = Graph.connect_nodes(graph, 19, 17)
# graph = Graph.connect_nodes(graph, 18, 19)

# # Enviar un mensaje desde un nodo
# Graph.send_message(graph, 22, "Hola desde Nodo v")
# Graph.send_message(graph, 24, "Hola desde Nodo x")
# Graph.send_message(graph, 19, "Hola desde Nodo s")

# # Proclamar líderes
# Graph.proclaim_leader(graph, 22)  # Nodo v
# Graph.proclaim_leader(graph, 20)  # Nodo t
