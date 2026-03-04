import gleam/list
import lib/element
import lib/move

pub type PokemonError {
  ElementLimitReached
  MoveLimitReached
}

pub type Pokemon {
  Pokemon(name: String, elements: List(element.Element), moves: List(move.Move))
}

pub fn new(name) -> Pokemon {
  Pokemon(name:, elements: [], moves: [])
}

pub fn with_element(
  pokemon: Pokemon,
  element: element.Element,
) -> Result(Pokemon, PokemonError) {
  case list.length(pokemon.elements) {
    2 ->  Error(ElementLimitReached)
    _ -> Ok(Pokemon(..pokemon, elements: [element, ..pokemon.elements]))
  }
}

pub fn with_move(
  pokemon: Pokemon,
  move: move.Move,
) -> Result(Pokemon, PokemonError) {
  case list.length(pokemon.moves) {
  4 -> Error(MoveLimitReached)
    _ -> Ok(Pokemon(..pokemon, moves: [move, ..pokemon.moves]))
  }
}
