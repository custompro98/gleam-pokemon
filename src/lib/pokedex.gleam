import gleam/result
import lib/element
import lib/movedex
import lib/pokemon

pub fn squirtle() -> pokemon.Pokemon {
  let assert Ok(squirtle) =
    pokemon.new("Squirtle")
    |> pokemon.with_stats(pokemon.BaseStats(
      hp: 50.0,
      attack: 100.0,
      defense: 200.0,
      special_attack: 100.0,
      special_defense: 200.0,
      speed: 30.0,
    ))
    |> pokemon.with_stats(pokemon.CurrentStats(
      hp: 50.0,
      attack: 100.0,
      defense: 200.0,
      special_attack: 100.0,
      special_defense: 200.0,
      speed: 30.0,
    ))
    |> pokemon.with_element(element.Water)
    |> result.try(fn(p) { pokemon.with_move(p, movedex.pound()) })

  squirtle
}

pub fn charmander() -> pokemon.Pokemon {
  let assert Ok(charmander) =
    pokemon.new("Charmander")
    |> pokemon.with_stats(pokemon.BaseStats(
      hp: 50.0,
      attack: 100.0,
      defense: 200.0,
      special_attack: 100.0,
      special_defense: 200.0,
      speed: 30.0,
    ))
    |> pokemon.with_stats(pokemon.CurrentStats(
      hp: 50.0,
      attack: 100.0,
      defense: 200.0,
      special_attack: 100.0,
      special_defense: 200.0,
      speed: 30.0,
    ))
    |> pokemon.with_element(element.Fire)
    |> result.try(fn(p) { pokemon.with_move(p, movedex.scratch()) })

  charmander
}
