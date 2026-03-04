import gleam/int
import gleam/io
import gleam/option.{None, Some}
import gleam/result
import lib/battle
import lib/element
import lib/move
import lib/pokemon
import prng/random

type MainError {
  NoWinner
}

pub fn main() -> Nil {
  let seed = int.random(random.max_int) |> echo

  let _ =
    battle.new()
    |> battle.with_seed(random.new_seed(seed))
    |> result.try(fn(b) { battle.with_participant(b, squirtle()) })
    |> result.try(fn(b) { battle.with_participant(b, charmander()) })
    |> result.try(battle.start)
    |> result.map(fn(b) {
      case b.winner {
        Some(winner) -> Ok("Winner is " <> winner.name)
        None -> Error(NoWinner)
      }
    })
    |> result.map(fn(r) { result.map(r, io.println) })

  Nil
}

fn pound() -> move.Move {
  move.new("Pound")
  |> move.with_element(element.Normal)
}

fn squirtle() -> pokemon.Pokemon {
  let assert Ok(squirtle) =
    pokemon.new("Squirtle")
    |> pokemon.with_element(element.Water)
    |> result.try(fn(p) { pokemon.with_move(p, pound()) })

  squirtle
}

fn scratch() -> move.Move {
  move.new("Scratch")
  |> move.with_element(element.Normal)
}

fn charmander() -> pokemon.Pokemon {
  let assert Ok(charmander) =
    pokemon.new("Charmander")
    |> pokemon.with_element(element.Water)
    |> result.try(fn(p) { pokemon.with_move(p, scratch()) })

  charmander
}
