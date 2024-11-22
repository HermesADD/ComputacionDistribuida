defmodule Crypto do

  @block_fields [:data, :timestamp, :prev_hash]

  @doc "Calcula el has de un bloque"
  def hash(%{} = block) do
    block
    |> Map.take(@block_fields)
    |> encode_to_binary()
    |> simple_hash()
  end

  @doc "Calcula e inserta el hash en el bloque"
  def put_hash(%{} = block) do
    %{block | hash: hash(block)}
  end

  # ChatGPT me ayudó porque encode no acepta no binarios
  defp encode_to_binary(map) do
    map
    |> Enum.map(fn {_, value} -> "#{value}" end) # Convierte cada valor en string
    |> Enum.join()                               # Concatena todos los valores en un solo string
    |> :erlang.binary_to_list()                  # Convierte el string a binario
  end

  defp simple_hash(binary) do
    :erlang.phash2(binary) |> Integer.to_string(16)
  end
end

defmodule Network do
  @moduledoc """
  Maneja la red de nodos y su interconexión usando el modelo Watts-Strogatz.
  """

  @doc """
  Construye una red inicial de `n` nodos con `k` conexiones por nodo
  y probabilidad de reconexión `beta`

  ## Parámetros
    - `n`: Número total de nodos.
    - `k`: Número de conexiones por nodo.
    - `beta`: Probabilidad de reconectar un nodo aleatoriamente.
  """
  def build_network(n, k, beta) do
    # Crear el anillo inicial
    initial_ring = for i <- 0..(n-1), do: {i, ring_neighbors(i, n, k)}

    # Reconectar con probabilidad beta
    Enum.reduce(initial_ring, Map.new(initial_ring), fn {node, neighbors}, acc ->
      rewired_neighbors = rewire_neighbors(node, neighbors, n, beta, acc)
      Map.put(acc, node, rewired_neighbors)
    end)
  end

  #Calcula los vecinos en el anillo inicial.
  defp ring_neighbors(node, n, k) do
    for i <- 1..div(k, 2),
        neighbor <- [rem(node + i + n, n), rem(node - i + n, n)],
        do: neighbor
  end

  #Reconecta veciones con probabilidad 'beta'.
  defp rewire_neighbors(node, neighbors, n, beta, network) do
    Enum.map(neighbors, fn neighbor ->
      if :rand.uniform() < beta do
        new_neighbor = get_random_node(n, [node | neighbors])
        new_neighbor
      else
        neighbor
      end
    end)
  end

  #Genera un nodo aleatorio que no está en la lista de excluidos
  defp get_random_node(n, excluded) do
    candidate = :rand.uniform(n) - 1
    if candidate in excluded do
      get_random_node(n, excluded)
    else
      candidate
    end
  end
end

defmodule Block do
  @moduledoc """
  Representa un bloque en una blockchain con datos, timestamp, hash y hash previo.
  """

  defstruct [:data, :timestamp, :prev_hash, :hash]

  @doc """
  Crea un nuevo bloque con los datos y hash previo especificados.

  ## Parámetros
    - `data`: Datos del bloque.
    - `prev_hash`: Hash del bloque anterior.
  """
  def new(data, prev_hash) do
    block = %Block{
      data: data,
      timestamp: DateTime.utc_now(),
      prev_hash: prev_hash
    }

    %{block | hash: Crypto.hash(block)}
  end

  @doc """
  Verifica si un bloque es válido.
  """
  def valid?(block) do
    cond do
      # Verifica que el hash sea correcto
      block.hash != Crypto.hash(block) ->
        {:error, "Hash inválido"}

      # Rechaza datos que parezcan maliciosos
      is_binary(block.data) && String.starts_with?(block.data, "INVALID_DATA_") ->
        {:error, "Datos maliciosos detectados"}

      # Verifica que el timestamp no esté en el futuro
      DateTime.compare(block.timestamp, DateTime.utc_now()) == :gt ->
        {:error, "Timestamp inválido"}

      true ->
        {:ok, block}
    end
  end

  @doc """
  Verifica si dos bloques consecutivos son válidos.
  """
  def valid?(block1, block2) do
    with {:ok, _} <- valid?(block1),
         {:ok, _} <- valid?(block2) do
      if block2.prev_hash == block1.hash do
        {:ok, block2}
      else
        {:error, "Hash previo no coincide"}
      end
    end
  end

  @doc """
  Devuelve el bloque como una cadena.
  """
  def to_string(block) do
    """
    +------------------------+
    | Bloque: #{String.slice(block.hash, 0..6)}
    |------------------------
    | Datos: #{block.data}
    | Timestamp: #{Calendar.strftime(block.timestamp, "%Y-%m-%d %H:%M:%S")}
    | Hash Previo: #{block.prev_hash}
    | Hash: #{block.hash}
    +------------------------+
    """
  end
end

defmodule Blockchain do
  @moduledoc """
  Representa una blockchain que permite agregar y validar bloques.
  """

  @doc """
  Inserta un nuevo bloque en la cadena. Si el bloque es válido, lo agrega a la cadena.

  ## Parámetros
  - `chain`: La cadena actual de bloques (lista de bloques).
  - `data`: Los datos que se almacenarán en el nuevo bloque.

  ## Retorno
  - `{:ok, chain}`: Si el bloque es válido, se devuelve la nueva cadena con el bloque agregado.
  - `{:error, reason}`: Si el bloque no es válido, se devuelve un mensaje de error.
  """
  def insert(chain, data) when is_list(chain) do
    prev_block = List.last(chain) || %Block{hash: "0"}
    new_block = Block.new(data, prev_block.hash)

    case validate_block_for_chain(new_block, chain) do
      {:ok, _} -> {:ok, chain ++ [new_block]}
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Valida un bloque específico para ser añadido a la cadena.
  """
  def validate_block_for_chain(block, chain) do
    cond do
      # Verifica si el bloque ya existe en la cadena
      Enum.any?(chain, fn existing -> existing.hash == block.hash end) ->
        {:error, "Bloque duplicado"}

      # Verifica si el hash previo coincide con el último bloque
      chain != [] && List.last(chain).hash != block.prev_hash ->
        {:error, "Hash previo no coincide con el último bloque"}

      # Valida el bloque en sí mismo
      true ->
        Block.valid?(block)
    end
  end

  @doc """
  Valida si la cadena de bloques es consistente.

  Recorre la cadena de bloques y asegura que cada bloque esté correctamente conectado con el anterior.

  ## Parámetros
  - `chain`: La cadena de bloques a validar.

  ## Retorno
  - `true`: Si la cadena es válida.
  - `false`: Si la cadena no es válida.
  """
  def valid?([]), do: true
  def valid?([_block]), do: true
  def valid?(chain) do
    chain
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.reduce_while({:ok, []}, fn [block1, block2], {:ok, _} ->
      case Block.valid?(block1, block2) do
        {:ok, _} -> {:cont, {:ok, [block1, block2]}}
        {:error, reason} -> {:halt, {:error, reason}}
      end
    end)
  end

  @doc """
  Convierte la cadena de bloques a una representación en cadena de texto.

  ## Parámetros
  - `chain`: La cadena de bloques.

  ## Retorno
  - Una cadena de texto representando la cadena de bloques.
  """
  def to_string(chain) do
    chain
    |> Enum.map(&Block.to_string/1)
    |> Enum.join("\n")
  end
end

defmodule BlockchainNode do
  require Logger

  @moduledoc """
  Representa un nodo en la red de blockchain.
  """

  @doc """
  Inicia un nodo en la red con un identificador único, una lista de vecinos y un indicador de si es bizantino.

  ## Parámetros
  - `id`: Identificador único del nodo.
  - `neighbors`: Lista de vecinos del nodo (identificadores de otros nodos).
  - `byzantine?`: Indicador opcional de si el nodo es bizantino (por defecto es `false`).

  ## Retorno
  - Un PID del proceso que representa el nodo.
  """
  def start(id, neighbors, byzantine? \\ false) do
    pid = spawn(fn ->
      Logger.info("Nodo #{id} iniciado (#{if byzantine?, do: "BIZANTINO", else: "NORMAL"})")
      loop(%{
        id: id,
        neighbors: neighbors,
        blockchain: [],
        byzantine?: byzantine?,
        processed_blocks: MapSet.new()
      })
    end)
    Process.register(pid, :"node_#{id}")
    pid
  end

  @doc """
  Obtiene la cadena de bloques de un nodo.

  ## Parámetros
  - `id`: Identificador del nodo.

  ## Retorno
  - La cadena de bloques del nodo.
  """
  def get_blockchain(id) do
    send(:"node_#{id}", {:get_blockchain, self()})
    receive do
      {:blockchain, chain} -> chain
    after
      5000 -> {:error, :timeout}
    end
  end

  @doc """
  Proponer un bloque desde un nodo.

  ## Parámetros
  - `id`: Identificador del nodo.
  - `data`: Datos del nuevo bloque a proponer.
  """
  def propose_block(id, data) do
    send(:"node_#{id}", {:propose_block, data})
  end

  # Función principal de bucle que maneja los mensajes recibidos por el nodo.
  defp loop(state) do
    receive do
      {:get_blockchain, from} ->
        send(from, {:blockchain, state.blockchain})
        loop(state)

      {:propose_block, data} when state.byzantine? ->
        Logger.warn("Nodo #{state.id} (bizantino) generando bloque malicioso")
        garbage_block = Block.new("INVALID_DATA_#{:rand.uniform(1000)}", "INVALID_HASH")
        broadcast_to_neighbors(state.neighbors, {:validate_block, garbage_block})
        loop(state)

      {:propose_block, data} ->
        case Blockchain.insert(state.blockchain, data) do
          {:ok, new_chain} ->
            new_block = List.last(new_chain)
            Logger.info("Nodo #{state.id} creó nuevo bloque: #{String.slice(new_block.hash, 0..6)}")
            broadcast_to_neighbors(state.neighbors, {:validate_block, new_block})
            loop(%{state | blockchain: new_chain})
          {:error, reason} ->
            Logger.error("Nodo #{state.id}: Error al crear bloque - #{reason}")
            loop(state)
        end

      {:validate_block, block} ->
        cond do
          # Verifica si ya procesamos este bloque
          MapSet.member?(state.processed_blocks, block.hash) ->
            loop(state)

          # Si somos bizantinos, solo propagamos el bloque
          state.byzantine? ->
            broadcast_to_neighbors(state.neighbors, {:validate_block, block})
            loop(%{state | processed_blocks: MapSet.put(state.processed_blocks, block.hash)})

          # Nodo normal: validar y posiblemente agregar el bloque
          true ->
            case Blockchain.validate_block_for_chain(block, state.blockchain) do
              {:ok, _} ->
                new_chain = state.blockchain ++ [block]
                broadcast_to_neighbors(state.neighbors, {:validate_block, block})
                loop(%{state |
                  blockchain: new_chain,
                  processed_blocks: MapSet.put(state.processed_blocks, block.hash)
                })
              {:error, reason} ->
                Logger.warn("Nodo #{state.id}: Rechazando bloque - #{reason}")
                loop(%{state |
                  processed_blocks: MapSet.put(state.processed_blocks, block.hash)
                })
            end
        end
    end
  end

  # Envía un mensaje a todos los nodos vecinos.
  #
  # Parámetros:
  #   - neighbors: Lista de identificadores de nodos vecinos.
  #   - message: Mensaje a enviar a cada vecino.
  defp broadcast_to_neighbors(neighbors, message) do
    Enum.each(neighbors, fn neighbor ->
      send(:"node_#{neighbor}", message)
    end)
  end
end

defmodule Main do
  require Logger

  @moduledoc """
  Módulo principal para gestionar la red de nodos blockchain.
  """

  @doc """
  Inicia la red de blockchain con un número de nodos y nodos bizantinos.

  ## Parámetros
  - `n`: Número total de nodos.
  - `f`: Número de nodos bizantinos.

  ## Retorno
  - La red de nodos con sus conexiones.
  """
  def run(n, f) when n > 3 * f do
    Logger.info("\nIniciando red blockchain con #{n} nodos (#{f} bizantinos)")

    network = Network.build_network(n, 4, 0.5)

    # Iniciar nodos normales
    Enum.each(0..(n-f-1), fn id ->
      BlockchainNode.start(id, Map.get(network, id))
    end)

    # Iniciar nodos bizantinos
    Enum.each((n-f)..(n-1), fn id ->
      BlockchainNode.start(id, Map.get(network, id), true)
    end)

    Logger.info("Red blockchain iniciada")
    network
  end

  @doc """
  Propone una nueva transacción desde un nodo especificado.

  ## Parámetros
  - `node_id`: El identificador del nodo que está proponiendo la transacción.
  - `data`: Los datos de la nueva transacción que se propondrán.
  """
  def propose_transaction(node_id, data) do
    Logger.info("\nNueva transacción desde nodo #{node_id}: #{data}")
    BlockchainNode.propose_block(node_id, data)

    # Dar tiempo para que la transacción se propague
    Process.sleep(1000)
  end

  @doc """
  Obtiene la cadena de bloques de un nodo y la imprime en consola.

  ## Parámetros
  - `node_id`: El identificador del nodo cuyo blockchain se desea obtener.

  ## Retorno
  - La cadena de bloques del nodo.
  """
  def get_blockchain(node_id) do
    chain = BlockchainNode.get_blockchain(node_id)
    IO.puts("\nBlockchain del nodo #{node_id}:")
    IO.puts(Blockchain.to_string(chain))
    chain
  end

  @doc """
  Imprime el estado actual de la red de nodos, mostrando qué nodos son normales y cuáles son bizantinos.

  ## Parámetros
  - `network`: El mapa que representa la red de nodos y sus conexiones.
  """
  def print_network_status(network) do
    IO.puts("\nEstado de la Red:")
    Enum.each(network, fn {node, neighbors} ->
      type = if node >= map_size(network) - 1, do: "BIZANTINO", else: "NORMAL"
      IO.puts("Nodo #{node} (#{type}) - Vecinos: #{inspect(neighbors)}")
    end)
  end
end

# Ejemplo de uso
network = Main.run(10, 1)
Main.print_network_status(network)
Main.propose_transaction(0, "Transferencia: Alice -> Bob: $100")
Main.propose_transaction(1, "Transferencia: Bob -> Charlie: $20")
Main.propose_transaction(2, "Transferencia: Charlie -> Alice: $30")
Main.get_blockchain(0)
