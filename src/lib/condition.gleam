import lib/number

pub type Condition(a) {
  And(List(Condition(a)))
  Or(List(Condition(a)))
  Not(Condition(a))
  Probability(Condition(a), Float)

  EqualTo(number.Number)
  LessThan(number.Number)
  LessThanOrEqualTo(number.Number)
  GreaterThan(number.Number)
  GreaterThanOrEqualTo(number.Number)
}
