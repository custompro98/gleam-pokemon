import gleam/list
import gleam/float
import lib/battle.{type Battle, Battle}
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
      let generator = random.float(0.0, 1.0)
      let #(rng, new_seed) = random.step(generator, battle.seed)

      let normalized_min = float.ceiling(min)
      let normalized_max = float.floor(max)

      let between =
        float.floor(
          rng *. { normalized_max -. normalized_min +. 1.0 } +. normalized_min,
        )

      #(between, Battle(..battle, seed: new_seed))
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
  }
}
