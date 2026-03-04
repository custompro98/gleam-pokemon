import gleam/int
import lib/battle
import lib/element
import lib/move
import lib/pokemon
import prng/random

pub fn main() -> Nil {
  int.range(from: 0, to: 10, with: [], run: fn(acc, seed) {
    let result =
      battle.new()
      |> battle.with_seed(random.new_seed(seed))
      |> battle.with_participant(squirtle())
      |> battle.with_participant(charmander())
      |> battle.start()

    [result, ..acc]
  })

  Nil
}

fn squirtle() {
  pokemon.new("Squirtle")
  |> pokemon.with_element(element.Water)
  |> pokemon.with_move(move.new("Pound") |> move.with_element(element.Normal))
}

fn charmander() {
  pokemon.new("Charmander")
  |> pokemon.with_element(element.Fire)
  |> pokemon.with_move(move.new("Scratch") |> move.with_element(element.Normal))
}
