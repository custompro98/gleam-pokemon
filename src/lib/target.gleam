import lib/battle

pub type TargetError {
  BattleNotStarted
}

pub type Target {
  Attacker
  Defender
}

pub fn get(
  battle: battle.Battle,
  target: Target,
) -> Result(battle.Battler, TargetError) {
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
