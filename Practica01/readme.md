# Práctica 01

> Computación Distribuida.
> Semestre 2025-01.
> Salvador López Mendoza
> Santiago Arroyo Lozano

## Equipo 
- Hermes Alberto Delgado Diaz, 319258613
- José Eduardo Cruz Campos, 319312087

## Comandos 

Para ejecutar las pruebas

```shell
?- elixir p01.ex
```

Para probar las funciones

```shell
?- iex
iex(1)> c "p01.ex"
iex(2)> P01."nombreDeLaFuncion(parametros)"
```

## Observaciones

- En algunas funciones se utilizo el modulo Map, en especifico Mas.has_key? y Map.delete(parametro), en este caso para facilitar la lectura del codigo, esto fue previamente investigado de la siguiente fuente https://hexdocs.pm/elixir/1.12/Map.html
- En la función Encapsular se utlizo el modulo Enum, esto por la dificultad al tratar de desarrollar la función, el test lo pasa sin problemas, sin embargo algunas veces no, no se pudo arreglar el error ya que no siempre te marca fail en el test y no se pudo encontrar el problema. La fuente donde se saco información del modulo Enum https://hexdocs.pm/elixir/1.12/Enum.html
- La fuente principal donde nos apoyamos para realizar la práctica es la siguiente https://elixir-lang.org/docs.html
