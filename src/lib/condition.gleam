import lib/pokemon
import gleam/list
import gleam/option.{Some}
import lib/battle
import lib/element
import lib/number

pub type ConditionError {
  BattleNotStarted
}

pub type Condition {
  And(List(Condition))
  Or(List(Condition))
  Not(Condition)

  Probability(chance: number.Number)

  For(Target, BattlerCondition)
}

pub fn evaluate(
  over battle: battle.Battle,
  with condition: Condition,
) -> Result(#(Bool, battle.Battle), ConditionError) {
  case condition {
    And(requirements) -> {
      list.fold(requirements, Ok(#(True, battle)), fn(acc, requirement) {
        case acc {
          // Short circuit if we know the result is False
          Ok(#(False, battle)) -> Ok(#(False, battle))
          Ok(#(True, battle)) ->
            case evaluate(battle, requirement) {
              Ok(result) -> Ok(result)
              Error(err) -> Error(err)
            }
          Error(err) -> Error(err)
        }
      })
    }
    Or(requirements) -> {
      list.fold(requirements, Ok(#(False, battle)), fn(acc, requirement) {
        case acc {
          // Short circuit if we know the result is True
          Ok(#(True, battle)) -> Ok(#(True, battle))
          Ok(#(False, battle)) ->
            case evaluate(battle, requirement) {
              Ok(result) -> Ok(result)
              Error(err) -> Error(err)
            }
          Error(err) -> Error(err)
        }
      })
    }
    Not(inner) -> {
      case evaluate(battle, inner) {
        Ok(#(ok, battle)) -> Ok(#(!ok, battle))
        Error(err) -> Error(err)
      }
    }
    Probability(chance) -> {
      let #(chance_value, battle) = number.calculate_number(chance, battle)
      let #(rng, battle) =
        number.calculate_number(number.Between(0.0, 1.0), battle)

      let ok = rng <. chance_value
      Ok(#(ok, battle))
    }
    For(target, battler_condition) -> {
      case get_target(battle, target) {
        Ok(target) ->
          case battler_resolver(target, battler_condition) {
            Ok(result) -> Ok(#(result, battle))
            Error(err) -> Error(err)
          }
        Error(err) -> Error(err)
      }
    }
  }
}

pub type NumberCondition {
  EqualTo(number.Number)
  LessThan(number.Number)
  LessThanOrEqualTo(number.Number)
  GreaterThan(number.Number)
  GreaterThanOrEqualTo(number.Number)
}

// TODO: Implement number_condition_resolver/2

pub type BattlerCondition {
  HasElement(element.Element)
  IsParalyzed
}

pub fn battler_resolver(
  battler: battle.Battler,
  condition: BattlerCondition,
) -> Result(Bool, ConditionError) {
  case condition {
    HasElement(element) -> Ok(pokemon.has_element(battler.pokemon, element))
    IsParalyzed -> Ok(battler.status == Some(battle.Paralyzed))
  }
}

pub type Target {
  Attacker
  Defender
}

fn get_target(
  battle: battle.Battle,
  target: Target,
) -> Result(battle.Battler, ConditionError) {
  case battle.turns {
    [turn, ..] -> {
      case target {
        Attacker -> Ok(turn.attacker)
        Defender -> Ok(turn.defender)
      }
    }
    [] -> Error(BattleNotStarted)
  }
}
