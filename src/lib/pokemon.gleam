import gleam/list
import lib/element
import lib/move

pub type PokemonError {
  ElementLimitReached
  MoveLimitReached
}

pub type Stats {
  BaseStats(
    hp: Float,
    attack: Float,
    defense: Float,
    special_attack: Float,
    special_defense: Float,
    speed: Float,
  )
  CurrentStats(
    hp: Float,
    attack: Float,
    defense: Float,
    special_attack: Float,
    special_defense: Float,
    speed: Float,
  )
}

pub opaque type Pokemon {
  Pokemon(
    name: String,
    elements: List(element.Element),
    moves: List(move.Move),
    base_stats: Stats,
    stats: Stats,
  )
}

pub fn new(name) -> Pokemon {
  Pokemon(
    name:,
    elements: [],
    moves: [],
    base_stats: BaseStats(0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
    stats: CurrentStats(0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
  )
}

pub fn with_element(
  pokemon: Pokemon,
  element: element.Element,
) -> Result(Pokemon, PokemonError) {
  case list.length(pokemon.elements) {
    2 -> Error(ElementLimitReached)
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

pub fn with_stats(pokemon: Pokemon, stats: Stats) -> Pokemon {
  case stats {
    BaseStats(_, _, _, _, _, _) -> Pokemon(..pokemon, base_stats: stats)
    CurrentStats(_, _, _, _, _, _) -> Pokemon(..pokemon, stats: stats)
  }
}

pub fn name(pokemon: Pokemon) -> String {
  pokemon.name
}

pub fn has_element(pokemon: Pokemon, element: element.Element) -> Bool {
  list.contains(pokemon.elements, element)
}
