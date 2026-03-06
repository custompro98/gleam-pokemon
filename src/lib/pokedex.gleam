import lib/movedex
import gleam/result
import lib/element
import lib/pokemon

pub fn squirtle() -> pokemon.Pokemon {
  let assert Ok(squirtle) =
    pokemon.new("Squirtle")
    |> pokemon.with_element(element.Water)
    |> result.try(fn(p) { pokemon.with_move(p, movedex.pound()) })

  squirtle
}

pub fn charmander() -> pokemon.Pokemon {
  let assert Ok(charmander) =
    pokemon.new("Charmander")
    |> pokemon.with_element(element.Fire)
    |> result.try(fn(p) { pokemon.with_move(p, movedex.scratch()) })

  charmander
}
