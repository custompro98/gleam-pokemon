import gleam/list
import gleam/option.{Some}
import lib/battle
import lib/element
import lib/number

pub type ConditionError {
  BattleNotStarted
}

pub type Condition(t) {
  And(List(Condition(t)))
  Or(List(Condition(t)))
  Not(Condition(t))

  Probability(chance: number.Number)

  /// This "escapes" to the specific domain types
  Predicate(t)
}

pub fn evaluate(
  over battle: battle.Battle,
  with condition: Condition(t),
  using resolver: fn(battle.Battle, t) -> Bool,
) -> #(Bool, battle.Battle) {
  case condition {
    And(requirements) -> {
      list.fold(requirements, #(True, battle), fn(acc, requirement) {
        let #(ok, battle) = acc
        case ok {
          True -> evaluate(battle, requirement, resolver)
          // Short circuit if we know the result is False
          False -> #(False, battle)
        }
      })
    }
    Or(requirements) -> {
      list.fold(requirements, #(False, battle), fn(acc, requirement) {
        let #(ok, battle) = acc
        case ok {
          // Short circuit if we know the result is True
          True -> #(True, battle)
          False -> evaluate(battle, requirement, resolver)
        }
      })
    }
    Not(inner) -> {
      let #(ok, battle) = evaluate(battle, inner, resolver)
      #(!ok, battle)
    }
    Probability(chance) -> {
      let #(chance_value, battle) = number.calculate_number(chance, battle)
      let #(rng, battle) =
        number.calculate_number(number.Between(0.0, 1.0), battle)

      let ok = rng <. chance_value
      #(ok, battle)
    }
    Predicate(predicate) -> #(resolver(battle, predicate), battle)
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
    HasElement(element) -> Ok(list.contains(battler.pokemon.elements, element))
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

pub type BattleCondition {
  For(Target, BattlerCondition)
}

pub fn battle_resolver(
  battle: battle.Battle,
  condition: BattleCondition,
) -> Result(Bool, ConditionError) {
  case condition {
    For(target, battler_condition) -> {
      let battler = get_target(battle, target)
      case battler {
        Ok(battler) -> battler_resolver(battler, battler_condition)
        Error(err) -> Error(err)
      }
    }
  }
}
