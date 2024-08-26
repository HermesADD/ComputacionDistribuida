ExUnit.start() # framework para pruebas unitarias en elixir

defmodule P01 do
  @moduledoc """
  Modulo con las funciones de la practica01
  """
  use ExUnit.Case # usamos el framework de pruebas caso por caso

  @doc """
  Calcula el cuadruple de un numero
  ## Parametro
    - `num`: El numero a cuadruplar.
  ## Retorna
    - El numero cuadriplicado
  ## Errores
    - Lanza `ArgumentError` si el parametro no es un numero
  """
  def cuadruple(num) do
    cond do
      is_number(num) ->
        num * 4
      not is_number(num) ->
        raise ArgumentError, "El parametro debe ser un numero"
    end
  end

  @doc """
  Calcula el sucesor de un numero
  ## Parametro
    - `num`: El numero que se calcula el sucesor.
  ## Retorna
    - El sucesor de num
  ## Errores
    - Lanza `ArgumentError` si el parametro no es un numero
  """
  def sucesor(num) do
    cond do
      is_number(num) ->
        num + 1
      not is_number(num) ->
        raise ArgumentError, "El parametro debe ser un numero"
    end
  end

  @doc """
  Calcula el maximo de dos numeros
  ## Parametro
    - `a`: El numero a.
    - `b`: El numero b.
  ## Retorna
    - El numero maximo
  ## Errores
    - Lanza `ArgumentError` si los parametros no son numeros
  """
  def maximo(a,b) do
    cond do
      is_number(a) and is_number(b) ->
        if a > b, do: a, else: b
      not is_number(a) ->
        raise ArgumentError, "Los parametros deben ser numeros"
      not is_number(b) ->
        raise ArgumentError, "Los parametros deben ser numeros"
    end
  end

  @doc """
  Calcula la suma de dos numeros
  ## Parametro
    - `a`: El numero a.
    - `b`: El numero b.
  ## Retorna
    - La suma de a y b
  ## Errores
    - Lanza `ArgumentError` si los parametros no son numeros
  """
  def suma(a,b) do
    cond do
      is_number(a) and is_number(b) ->
        a + b
      not is_number(a) ->
        raise ArgumentError, "Los parametros deben ser numeros"
      not is_number(b) ->
        raise ArgumentError, "Los parametros deben ser numeros"
    end
  end

  @doc """
  Calcula la resta de dos numeros
  ## Parametro
    - `a`: El numero a.
    - `b`: El numero b.
  ## Retorna
    - La resta de a y b
  ## Errores
    - Lanza `ArgumentError` si los parametros no son numeros
  """
  def resta(a,b) do
    cond do
      is_number(a) and is_number(b) ->
        a - b
      not is_number(a) ->
        raise ArgumentError, "Los parametros deben ser numeros"
      not is_number(b) ->
        raise ArgumentError, "Los parametros deben ser numeros"
    end
  end

  @doc """
  Calcula la multiplicacion de conjugados de dos numeros
  ## Parametro
    - `a`: El numero a.
    - `b`: El numero b.
  ## Retorna
    - La multiplicacion de congujados de a y b
  ## Errores
    - Lanza `ArgumentError` si los parametros no son numeros
  """
  def multiplicacionConjugados(a,b) do
    cond do
      is_number(a) and is_number(b) ->
        (a + b) * (a - b)
      not is_number(a) ->
        raise ArgumentError, "Los parametros deben ser numeros"
      not is_number(b) ->
        raise ArgumentError, "Los parametros deben ser numeros"
    end
  end

  @doc """
  Devuelve la negacion de un booleano
  ## Parametro
    - `bool`: El valor booleano
  ## Retorna
    - La negacion de bool
  ## Errores
    - Lanza `ArgumentError` si el parametro no es booleano
  """
  def negacion(bool) do
    cond do
      is_boolean(bool) ->
        if true == bool do
          false
        else
          true
        end
      not is_boolean(bool) ->
        raise ArgumentError, "El parametro debe ser un booleano"
    end
  end

  @doc """
  Devuelve la conjuncion de dos booleanos
  ## Parametro
    - `b1`: El valor booleano 1.
    - `b2`: El valor booleano 2.
  ## Retorna
    - La conjuncion de b1 & b2
  ## Errores
    - Lanza `ArgumentError` si los parametros no son booleanos
  """
  def conjuncion(b1, b2) do
    cond do
      is_boolean(b1) and is_boolean(b2) ->
        if b1 == true and b2 == true do
          true
        else
          false
        end
      not is_boolean(b1) ->
        raise ArgumentError, "Los parametros deben ser booleanos"
      not is_boolean(b2) ->
        raise ArgumentError, "Los parametros deben ser booleanos"
    end
  end

  @doc """
  Devuelve la disyuncion de dos booleanos
  ## Parametro
    - `b1`: El valor booleano b1.
    - `b2`: El valor booleano b2.
  ## Retorna
    - La disyuncion de b1 || b2
  ## Errores
    - Lanza `ArgumentError` si los parametros no son booleanos
  """
  def disyuncion(b1, b2) do
    cond do
      is_boolean(b1) and is_boolean(b2) ->
        cond do
          b1 == true and b2 == true ->
            true
          b1 == true and b2 == false ->
            true
          b1 == false and b2 == true ->
            true
          true ->
            false
        end
      not is_boolean(b1) ->
        raise ArgumentError, "Los parametros deben ser booleanos"
      not is_boolean(b2) ->
        raise ArgumentError, "Los parametros deben ser booleanos"
    end
  end

  @doc """
  Calcula el absoluto de un numero
  ## Parametro
    - `num`: El numero a calcular el absoluto.
  ## Retorna
    - El absoluto de num
  ## Errores
    - Lanza `ArgumentError` si el parametro no es un numero
  """
  def absoluto(num) do
    cond do
      is_number(num) ->
        if num < 0 do
          -1 * num
        else
          num
        end
      not is_number(num) ->
        raise ArgumentError, "El parametro debe ser un numero"
    end
  end

  @doc """
  Calcula el area del circulo
  ## Parametro
    - `num`: El radio del numero.
  ## Retorna
    - El area del circulo
  ## Errores
    - Lanza `ArgumentError` si el parametro no es un numero
  """
  def areaCirculo(num) do
    cond do
      is_number(num) ->
        3.14 * (num * num)
      not is_number(num) ->
        raise ArgumentError, "El parametro debe ser un numero"
    end
  end

  @doc """
  Calcula la suma de Gauss de n recursivamente
  ## Parametro
    - `num`: El numero al calcular la suma de Gauss.
  ## Retorna
    - La suma de Gauss
  ## Errores
    - Lanza `ArgumentError` si el parametro no es un numero
  """
  def sumaGaussRec(0), do: 0
  def sumaGaussRec(num) do
    cond do
      is_number(num) ->
        num + sumaGaussRec(num - 1)
      not is_number(num) ->
        raise ArgumentError, "El parametro debe ser un numero"
    end
  end

  @doc """
  Calcula la suma de Gauss de n
  ## Parametro
    - `num`: El numero al calcular la suma de Gauss.
  ## Retorna
    - La suma de Gauss
  ## Errores
    - Lanza `ArgumentError` si el parametro no es un numero
  """
  def sumaGauss(num) do
    cond do
      is_number(num) ->
        (num * (num + 1))/2
      not is_number(num) ->
        raise ArgumentError, "El parametro debe ser un numero"
    end
  end

  @doc """
  Calcula el area de un triangulo
  ## Parametro
    - `{x1,y1}`: Punto1 donde x1 y y1 son numeros.
    - `{x2,y2}`: Punto1 donde x2 y y2 son numeros.
    - `{x3,y3}`: Punto1 donde x3 y y3 son numeros.
  ## Retorna
    - El area del triangulo con puntos {x1,y1},{x2,y2},{x3,y3}
  ## Errores
    - Lanza `ArgumentError` si el parametro no son tuplas y no son numeros
  """
  def areaTriangulo({x1,y1},{x2,y2},{x3,y3}) do
    cond do
      is_tuple({x1, y1}) and is_number(x1) and is_number(y1) and
      is_tuple({x2, y2}) and is_number(x2) and is_number(y2) and
      is_tuple({x3, y3}) and is_number(x3) and is_number(y3) ->
        absoluto(x1 * (y2 - y3) + x2 * (y3 - y1) + x3 * (y1 - y2))/2
      true ->
        raise ArgumentError, "Los parametros deben ser tuplas y numeros"
      end
  end

  @doc """
  Repite la cadena n veces
  ## Parametro
    - `num`: veces a repetir la cadena.
    - `cadena`: cadena a repetir
  ## Retorna
    - Repeticion de la cadena
  ## Errores
    - Lanza `ArgumentError` si num es menor a 0 o no es un numero
  """
  def repiteCadena(num, _cadena) when num < 0  or not is_number(num) do
    raise ArgumentError, "El numero de repeticiones no puede ser negativo y debe ser un numero"
  end
  def repiteCadena(0, _cadena), do: []
  def repiteCadena(num, cadena) when num > 0 do
    [cadena | repiteCadena(num-1,cadena)]
  end

  @doc """
  Inserta un elemento en la lista
  ## Parametro
    - `lst`: lista a modificar.
    - `index`: posicion donde se insertara el elemento
    - `val`: elemento a insertar
  ## Retorna
    - Lista modificada
  ## Errores
    - Lanza `ArgumentError` si num es menor a 0 o no es un numero
  """
  def insertaElemento(_lst, index, _val) when index < 0 or not is_number(index) do
    raise ArgumentError, "El indice debe ser un numero, no puede ser negativo o mayor al tamano de la lista"
  end
  def insertaElemento(lst, 0, val), do: [val | lst]
  def insertaElemento([head | tail], index, val) when index > 0 do
    [head | insertaElemento(tail, index-1, val)]
  end

  @doc """
  Elimina un elemento en la lista
  ## Parametro
    - `lst`: lista a modificar.
    - `index`: posicion donde se eliminara el elemento
  ## Retorna
    - Lista modificada
  ## Errores
    - Lanza `ArgumentError` si index es mayor al tamano de la lista o menor a 0, o no es un numero
  """
  def eliminaIndex(lst, index) when index < 0 or index >= length(lst) or not is_number(index) do
    raise ArgumentError, "El index esta fuera de rango y debe ser un numero"
  end
  def eliminaIndex([], _index), do: []
  def eliminaIndex([_head | tail], 0), do: tail
  def eliminaIndex([head | tail], index) when index > 0 do
    [head | eliminaIndex(tail, index - 1)]
  end

  @doc """
  Obtiene el ultimo elemento de una lista.

  ## Parametros
    - `list`: Una lista de elementos.

  ## Returna
    - El ultimo elemento de la lista o `nil` si la lista está vacía.
  """
  def raboLista([]), do: nil
  def raboLista([head]), do: head
  def raboLista([_head|tail]), do: raboLista(tail)

  @doc """
  Combina listas de listas en tuplas.

  ## Parametros

    - `lists`: Una lista de listas que se desea combinar en tuplas.

  ## Retorna
    - Una lista de tuplas combinadas.
  """
  def encapsula(lists) do
    Enum.zip(lists)
  end

  @doc """
  Elimina una clave específica de un map si existe.

  ## Params
    - `map`: Un map de pares clave-valor.
    - `key`: La clave que se quiere eliminar del map.

  ## Returns
    - El map con la clave eliminada si existía, o el map original si la clave no estaba presente.
  """
  def mapBorra(map, key) do
    if Map.has_key?(map, key) do
      Map.delete(map, key)
    else
      map
    end
  end

  @doc """
  Convierte un map en una lista de pares clave-valor manteniendo el orden de las claves.

  ## Parametros
    - `map`: Un map de pares clave-valor.

  ## Returna
    - Una lista de pares clave-valor extraidos del map.
  """
  def mapAlista(map) do
    keys = Map.keys(map)
    mapAlista_aux(map, keys, [])
  end

  defp mapAlista_aux(_map, [], acc), do: acc

  defp mapAlista_aux(map, [key | rest], acc) do
    mapAlista_aux(map, rest, acc ++ [{key, Map.get(map, key)}])
  end

  @doc """
  Calcula la distancia entre dos puntos.

  ## Parametros
    - `p1`: Una tupla representando el primer punto (x1, y1).
    - `p2`: Una tupla representando el segundo punto (x2, y2).

  ## Returna
    - La distancia entre los dos puntos.

  ## Errores
    - Lanza `ArgumentError` si las entradas no son tuplas con exactamente dos números.
  """
  def dist(p1, p2) do
    validate_point(p1)
    validate_point(p2)

    {x1, y1} = p1
    {x2, y2} = p2

    :math.sqrt(:math.pow(x2 - x1, 2) + :math.pow(y2 - y1, 2))
  end

  defp validate_point({x, y}) when is_number(x) and is_number(y), do: :ok
  defp validate_point(_), do: raise(ArgumentError, "Ambas puntos deben ser tuplas con dos numeros")

  @doc """
  Inserta un elemento al final de una tupla.

  ## Parametros
    - `tuple`: Una tupla a la que se le quiere anadir un nuevo elemento.
    - `value`: El nuevo elemento a anadir.

  ## Returna
    - La tupla original con el nuevo elemento anadido.

  ## Errores
    - ArgumentError` si el primer argumento no es una tupla.
  """
  def insertaTupla(tuple, value) do
    validate_tuple(tuple)
    Tuple.append(tuple, value)
  end

  @doc """
  Convierte una tupla en una lista.

  ## Parametros
    - `tuple`: Una tupla que se quiere convertir en una lista.

  ## Returna
    - La lista correspondiente a la tupla.

  ## Errores
    - Lanza `ArgumentError` si el argumento no es una tupla.
  """
  def tuplaALista(tuple) do
    validate_tuple(tuple)
    Tuple.to_list(tuple)
  end

  defp validate_tuple(tuple) when is_tuple(tuple), do: :ok
  defp validate_tuple(_), do: (raise ArgumentError, "Input must be a tuple")

  # # ---------------------------------------- Pruebas ----------------------------------------
  test "pruebaCuadruple" do
    IO.puts " -> Probando cuadruple(num)"
    num = Enum.random(-1000..1000)
    assert cuadruple(num) == 4 * num
  end

  test "pruebaSucesor" do
    IO.puts " -> Probando sucesor(num)"
    num = Enum.random(-1000..1000)
    assert sucesor(num) == num + 1
  end

  test "pruebaMaximo" do
    IO.puts " -> Probando máximo(num1, num2)"
    assert maximo(5, 6) == 6
    assert maximo(7,6) == 7
    assert maximo(4,4) == 4
  end

  test "pruebaSuma" do
    IO.puts " -> Probando suma(num1, num2)"
    assert suma(5, 6) == 11
    assert suma(7,6) == 13
    assert suma(4,4) == 8
  end

  test "pruebaResta" do
    IO.puts " -> Probando resta(a, b)"
    assert resta(5, 3) == 2
    assert resta(7,6) == 1
    assert resta(4,4) == 0
  end

  test "pruebaMultiplicacionConjugada" do
    IO.puts " -> Probando multipliacionConjugados(a, b)"
    assert multiplicacionConjugados(5, 3) == 16
    assert multiplicacionConjugados(7,6) == 13
    assert multiplicacionConjugados(4,4) == 0
  end

  test "pruebaNegacion" do
    IO.puts " -> Probando negacion(bool)"
    assert negacion(true) == false
    assert negacion(false) == true
  end

  test "pruebaConjucion" do
    IO.puts " -> Probando conjuncion(bool1, bool2)"
    assert conjuncion(true, true) == true
    assert conjuncion(false, true) == false
    assert conjuncion(true, false) == false
    assert conjuncion(false, false) == false
  end

  test "pruebaDisyuncion" do
    IO.puts " -> Probando disyuncion(bool1, bool2)"
    assert disyuncion(true, true) == true
    assert disyuncion(false, true) == true
    assert disyuncion(true, false) == true
    assert disyuncion(false, false) == false
  end

  test "pruebaAbsoluto" do
    IO.puts " -> Probando absoluto(num)"
    assert absoluto(Enum.random(-1000..0)) >= 0
    assert absoluto(Enum.random(0..1000)) >= 0
    assert absoluto(-10) == 10
    assert absoluto(10) == 10
  end

  test "pruebaAreaCirculo" do
    IO.puts " -> Probando areaCirculo(r)"
    assert areaCirculo(1) == 3.14
    assert areaCirculo(2) == 12.56
  end

  test "pruebaSumaGaussRecursiva" do
    IO.puts " -> Probando sumaGaussRec(n)"
    assert sumaGaussRec(10) == 55
    assert sumaGaussRec(15) == 120
  end

  test "pruebaSumaGauss" do
    IO.puts " -> Probando sumaGauss(n)"
    assert sumaGauss(10) == 55
    assert sumaGauss(15) == 120
  end

  test "pruebaAreaTriangulo" do
    IO.puts " -> Probando areaTriangulo(a, b, c)"
    assert areaTriangulo({2,0}, {3,4}, {-2,5}) == 10.5
    assert areaTriangulo({3,4}, {4,7}, {6,-3}) == 8
  end

  test "pruebaRepiteCadena" do
    IO.puts " -> Probando repiteCadena(num, cadena)"
    assert repiteCadena(3, "hola") == ["hola", "hola", "hola"]
    assert repiteCadena(0, "mundo") == []
    assert repiteCadena(2, "") == ["", ""]
  end

  test "pruebaInsertaElemento" do
    IO.puts " -> Probando insertaElemento(lst, index, val)"
    assert insertaElemento([1, 2, 3], 1, 5) == [1, 5, 2, 3]
    assert insertaElemento([], 0, 10) == [10]
    assert insertaElemento([:a, :b, :c], 2, :d) == [:a, :b, :d, :c]
  end

  test "pruebaEliminaIndex" do
    IO.puts " -> Probando eliminaIndex(lst, index)"
    assert eliminaIndex([1, 2, 3], 1) == [1, 3]
    assert eliminaIndex([:a, :b, :c], 0) == [:b, :c]
    assert eliminaIndex([:x], 0) == []
  end

  test "pruebaRaboLista" do
    IO.puts " -> Probando raboLista(lst)"
    assert raboLista([1, 2, 3, 4]) == 4
    assert raboLista([:a, :b, :c]) == :c
    assert raboLista(["uno", "dos", "tres"]) == "tres"
    assert raboLista([]) == nil
  end

  test "pruebaEncapsula" do
    IO.puts " -> Probando encapsula(lst)"
    assert encapsula([[1, 2], [3, 4], [5, 6]]) == [{1, 3, 5}, {2, 4, 6}]
    assert encapsula([[:a, :b], [:c, :d]]) == [{:a, :c}, {:b, :d}]
    assert encapsula([[], []]) == []
  end

  test "pruebaMapBorra" do
    IO.puts " -> Probando mapBorra(map, key)"
    assert mapBorra(%{a: 1, b: 2, c: 3}, :b) == %{a: 1, c: 3}
    assert mapBorra(%{x: 10, y: 20}, :z) == %{x: 10, y: 20}
    assert mapBorra(%{}, :key) == %{}
  end

  test "pruebaMapAlista" do
    IO.puts " -> Probando mapAlista(map)"
    assert mapAlista(%{a: 1, b: 2}) == [a: 1, b: 2]
    assert mapAlista(%{}) == []
    assert mapAlista(%{x: 10}) == [x: 10]
  end

  test "pruebaDist" do
    IO.puts " -> Probando dist(a, b)"
    assert dist({0, 0}, {3, 4}) == 5.0
    assert dist({1, 1}, {1, 1}) == 0.0
    assert dist({-1, -1}, {1, 1}) == :math.sqrt(8)
  end

  test "pruebaInsertaTupla" do
    IO.puts " -> Probando insertaTupla(t, v)"
    assert insertaTupla({1, 2, 3}, 4) == {1, 2, 3, 4}
    assert insertaTupla({}, :a) == {:a}
    assert insertaTupla({:b}, :c) == {:b, :c}
  end

  test "pruebaTuplaALista" do
    IO.puts " -> Probando tuplaALista(t)"
    assert tuplaALista({1, 2, 3}) == [1, 2, 3]
    assert tuplaALista({}) == []
    assert tuplaALista({:a, :b}) == [:a, :b]
  end
end
