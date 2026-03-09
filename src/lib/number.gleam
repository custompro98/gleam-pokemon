import gleam/list
import lib/battle.{type Battle, Battle}
import lib/target
import prng/random

pub type WeightedNumber {
  WeightedNumber(weight: Float, value: Float)
}

pub type Number {
  Exactly(value: Float)
  Sum(a: Number, b: Number)
  Product(a: Number, b: Number)
  Quotient(dividend: Number, divisor: Number)
  Between(min: Float, max: Float)
  Weighted(List(WeightedNumber))
  MaxHP(target.Target)
}

pub fn calculate_number(number: Number, battle: Battle) -> #(Float, Battle) {
  case number {
    Exactly(value) -> #(value, battle)
    Sum(a, b) -> {
      let #(a_value, battle) = calculate_number(a, battle)
      let #(b_value, battle) = calculate_number(b, battle)

      #(a_value +. b_value, battle)
    }
    Product(a, b) -> {
      let #(a_value, battle) = calculate_number(a, battle)
      let #(b_value, battle) = calculate_number(b, battle)

      #(a_value *. b_value, battle)
    }
    Quotient(dividend, divisor) -> {
      let #(dividend_value, battle) = calculate_number(dividend, battle)
      let #(divisor_value, battle) = calculate_number(divisor, battle)

      #(dividend_value /. divisor_value, battle)
    }
    Between(min, max) -> {
      let generator = random.float(min, max)
      let #(rng, new_seed) = random.step(generator, battle.seed)

      #(rng, Battle(..battle, seed: new_seed))
    }
    Weighted(weights) -> {
      case weights {
        [only] -> {
          let generator = random.weighted(#(only.weight, only.value), [])
          let #(choice, new_seed) = random.step(generator, battle.seed)

          #(choice, Battle(..battle, seed: new_seed))
        }
        [only, ..rest] -> {
          let generator =
            random.weighted(
              #(only.weight, only.value),
              list.map(rest, fn(w) { #(w.weight, w.value) }),
            )
          let #(choice, new_seed) = random.step(generator, battle.seed)

          #(choice, Battle(..battle, seed: new_seed))
        }
        _ -> panic as "Weighted numbers must have at least one weight"
      }
    }
    MaxHP(target) -> {
      case target.get(battle, target) {
        Ok(battler) -> {
        todo
        }
        Error(err) ->
          case err {
            target.BattleNotStarted ->
              panic as "MaxHP must be used with a target"
          }
      }
    }
  }
}
