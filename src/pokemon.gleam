import gleam/int
import gleam/io
import gleam/option.{None, Some}
import gleam/result
import lib/battle
import lib/movedex
import lib/pokedex
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
    |> fn(b) { battle.with_participant(b, squirtle()) }
    |> result.try(fn(b) { battle.with_participant(b, charmander()) })
    |> result.try(battle.start)
    |> result.map(fn(b) {
      case b.winner {
        Some(winner) -> Ok("Winner is " <> pokemon.name(winner))
        None -> Error(NoWinner)
      }
    })
    |> result.map(fn(r) { result.map(r, io.println) })

  Nil
}

fn squirtle() -> pokemon.Pokemon {
  let assert Ok(squirtle) =
    pokedex.squirtle()
    |> pokemon.with_move(movedex.pound())

  squirtle
}

fn charmander() -> pokemon.Pokemon {
  let assert Ok(charmander) =
    pokedex.charmander()
    |> pokemon.with_move(movedex.scratch())

  charmander
}
