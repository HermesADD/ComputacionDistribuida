# Práctica 03

> Computación Distribuida.
> Semestre 2025-01.
> Salvador López Mendoza
> Santiago Arroyo Lozano

## Equipo 
- Hermes Alberto Delgado Diaz, 319258613
- José Eduardo Cruz Campos, 319312087

## Comandos 

### Para ejecutar el test

```shell
?- elixir p03.ex
```

### Para ejecutar las funciones

- spawn_in_list/4

```shell
?- iex p03.ex
iex(1)> Practica03.spawn_in_list(4, Graph, :start_graph, [])
iex(2)> [#PID<0.117.0>,#PID<0.118.0>,#PID<0.119.0>,#PID<0.120.0>]
```

- genera/1

```shell
?- iex p03.ex
iex(1)> lista = Practica03.genera(4)
iex(2)> [#PID<0.117.0>,#PID<0.118.0>,#PID<0.119.0>,#PID<0.120.0>]
```

- send_msg/2

```shell
?- iex p03.ex
iex(1)> Practica.send_msg(lista, {:inicia})
{:ok}
```


## Notas 

Se modificó el módulo Graph con los comentarios en la práctica anterior.
Se eliminó el módulo GraphNode.

Como se tuvieron problemas para ejecutar el test, se decidió agregarlo en el mismo archivo que los módulos Graph y Practica03.

Al ejecutar lanza una advertencia ya que se documento una función privada.

## Referencias para poder realizar la práctica
- Canal de youtube "makigas: aprende programación" donde se ve un poco de concurrencia https://www.youtube.com/watch?v=e7MWONJmCxM&list=PLTd5ehIj0goMXbOG61Hm7MlKTuLAfWhc5&pp=iAQB
- https://hexdocs.pm/elixir/introduction.html
- https://elixirschool.com/es/lessons/intermediate/concurrency
- https://www.makigas.es/series/concurrencia-en-elixir
- https://carlogilmar.xyz/es/posts/process_part1/
