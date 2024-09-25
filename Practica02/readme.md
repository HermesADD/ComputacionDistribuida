# Práctica 02

> Computación Distribuida.
> Semestre 2025-01.
> Salvador López Mendoza
> Santiago Arroyo Lozano

## Equipo 
- Hermes Alberto Delgado Diaz, 319258613
- José Eduardo Cruz Campos, 319312087

## Comandos 

Para ejecutar 

```shell
?- elixir p02.ex
```

## Funcionamiento del algoritmo elección líder
Si el id del nodo que se postula para líder es menor a sus vecinos, estos lo aceptan como líder y le dicen a sus vecinos que es su líder.
En otro caso no lo acepta.
Además si hay un nuevo candidato, si este se postula líder y sus vecinos tienen ya un líder pero su id es mayor al que se postula, entonces el 
postulado es el nuevo líder.

En la ejecución del programa se notara que primero se acepta como líder al nodo t con id 22, pero despues se postula el nodo t con id 20, 
entonces todos los nodos que tenian como lider a 22, cambian a 20. 

En la gráfica declarada, se puede notar que es no conexa, por lo tanto las componentes conexas no tienen conexión y no pueden transmitirse el líder.

## Notas 
En la práctica se definieron dos modulos, uno llamado GraphNode que representa un nodo de la gráfica, este al principio se iba a llamar Node, sin embargo
Elixir indicaba una advertencia al usar este nombre. El otro modulo se llama Graph que representa la gráfica y comunica a los nodos.

## Referencias para poder realizar la práctica
- Canal de youtube "makigas: aprende programación" donde se ve un poco de concurrencia https://www.youtube.com/watch?v=e7MWONJmCxM&list=PLTd5ehIj0goMXbOG61Hm7MlKTuLAfWhc5&pp=iAQB
- https://hexdocs.pm/elixir/introduction.html
- https://elixirschool.com/es/lessons/intermediate/concurrency
- https://www.makigas.es/series/concurrencia-en-elixir
- https://carlogilmar.xyz/es/posts/process_part1/
