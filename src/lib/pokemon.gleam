import gleam/list
import lib/element
import lib/move

pub type Pokemon {
  Pokemon(name: String, element: List(element.Element), moves: List(move.Move))
}

pub fn new(name) -> Pokemon {
  Pokemon(name:, element: [], moves: [])
}

pub fn with_element(pokemon: Pokemon, element: element.Element) -> Pokemon {
  case list.length(pokemon.element) {
    2 -> panic as "Pokemon can only have up to two elements"
    _ -> Pokemon(..pokemon, element: [element, ..pokemon.element])
  }
}

pub fn with_move(pokemon: Pokemon, move: move.Move) -> Pokemon {
  case list.length(pokemon.moves) {
    4 -> panic as "Pokemon can only have up to four moves"
    _ -> Pokemon(..pokemon, moves: [move, ..pokemon.moves])
  }
}
