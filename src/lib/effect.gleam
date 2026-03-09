import gleam/float
import gleam/io
import lib/battle
import lib/number
import lib/pokemon
import lib/target

pub type EffectError {
  InvalidTarget
}

pub type Effect {
  NoEffect
  Faint(target.Target)
  DirectDamage(target.Target, number.Number)
  OHKO(target.Target)
}

pub fn apply(
  effect: Effect,
  battle: battle.Battle,
) -> Result(battle.Battle, EffectError) {
  case effect {
    NoEffect -> {
      io.println("There was no effect")
      Ok(battle)
    }
    Faint(target) -> {
      case target.get(battle, target) {
        Ok(battler) -> {
          io.println(pokemon.name(battler.pokemon) <> " fainted")
          Ok(battle)
        }
        Error(err) ->
          case err {
            target.BattleNotStarted -> Error(InvalidTarget)
          }
      }
    }
    DirectDamage(target, damage) -> {
      case target.get(battle, target) {
        Ok(battler) -> {
          let #(damage, battle) = number.calculate_number(damage, battle)
          io.println(
            pokemon.name(battler.pokemon) <> " took " <> float.to_string(damage),
          )
          Ok(battle)
        }
        Error(err) ->
          case err {
            target.BattleNotStarted -> Error(InvalidTarget)
          }
      }
    }
    OHKO(target) -> {
      case target.get(battle, target) {
        Ok(battler) -> {
          io.println(
            pokemon.name(battler.pokemon)
            <> " was KO'd"
          )
          Ok(battle)
        }
        Error(err) ->
          case err {
            target.BattleNotStarted -> Error(InvalidTarget)
          }
      }
    }
  }
}
