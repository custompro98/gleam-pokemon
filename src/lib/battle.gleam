import gleam/int
import gleam/io
import gleam/list
import gleam/option.{type Option, None, Some}
import lib/pokemon
import prng/random

type Battler {
  Attacker(pokemon: pokemon.Pokemon)
  Defender(pokemon: pokemon.Pokemon)
}

pub opaque type Turn {
  Turn(attacker: Battler, defender: Battler)
}

pub type Battle {
  Battle(
    participants: List(pokemon.Pokemon),
    turns: List(Turn),
    winner: Option(pokemon.Pokemon),
    seed: random.Seed,
  )
}

fn new_attacker(pokemon: pokemon.Pokemon) -> Battler {
  Attacker(pokemon)
}

fn new_defender(pokemon: pokemon.Pokemon) -> Battler {
  Defender(pokemon)
}

pub fn new() -> Battle {
  let seed = random.new_seed(int.random(random.max_int))
  Battle(participants: [], turns: [], winner: None, seed:)
}

fn new_turn(attacker attacker: Battler, defender defender: Battler) -> Turn {
  Turn(attacker, defender)
}

pub fn with_participant(battle: Battle, pokemon: pokemon.Pokemon) -> Battle {
  case list.length(battle.participants) {
    2 -> panic as "Battles can only have two participants"
    _ -> Battle(..battle, participants: [pokemon, ..battle.participants])
  }
}

pub fn with_seed(battle: Battle, seed: random.Seed) -> Battle {
  Battle(..battle, seed:)
}

pub fn start(battle: Battle) -> Nil {
  case battle.participants {
    [first, second] -> {
      let attacker = new_attacker(first)
      let defender = new_defender(second)
      // TODO: determine who goes first based on speed or some other stat, for now we'll just have the first participant be the attacker
      let turn = new_turn(attacker:, defender:)
      let battle = Battle(..battle, turns: [turn, ..battle.turns])

      perform_turn(turn, battle)
    }
    _ -> panic as "Battles must have exactly two participants"
  }
}

fn perform_turn(turn: Turn, battle: Battle) -> Nil {
  case battle.winner {
    Some(pokemon) -> {
      io.println("The battle is over! The winner is " <> pokemon.name)
    }
    None -> {
      // TODO: implement actual battle logic here, for now we'll just randomly decide if the attacker wins or not
      let rng = int.random(2)
      let has_winner = rng == 1
      case has_winner {
        True -> {
          let battle = Battle(..battle, winner: Some(turn.attacker.pokemon))
          perform_turn(
            new_turn(attacker: turn.defender, defender: turn.attacker),
            battle,
          )
        }
        False -> {
          let turn = new_turn(attacker: turn.defender, defender: turn.attacker)
          let battle = Battle(..battle, turns: [turn, ..battle.turns])
          perform_turn(turn, battle)
        }
      }
    }
  }
}
