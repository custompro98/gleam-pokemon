pub type Element {
  Normal
  Fire
  Water
  Electric
  Grass
  Ice
  Fighting
  Poison
  Ground
  Flying
  Psychic
  Bug
  Rock
  Ghost
  Dragon
  Dark
  Steel
  Fairy
}

pub fn multiplier(attacker: Element, defender: Element) -> Float {
  case defender {
    Normal ->
      case attacker {
        Fighting -> 2.0
        Ghost -> 0.0
        _ -> 1.0
      }
    Fire -> {
      case attacker {
        Bug -> 0.5
        Fairy -> 0.5
        Fire -> 0.5
        Grass -> 0.5
        Ground -> 2.0
        Ice -> 0.5
        Rock -> 2.0
        Steel -> 0.5
        Water -> 2.0
        _ -> 1.0
      }
    }
    Water -> {
      case attacker {
        Electric -> 2.0
        Fire -> 0.5
        Grass -> 2.0
        Ice -> 0.5
        Steel -> 0.5
        Water -> 0.5
        _ -> 1.0
      }
    }
    Electric -> {
      case attacker {
        Electric -> 0.5
        Flying -> 0.5
        Ground -> 2.0
        Steel -> 0.5
        _ -> 1.0
      }
    }
    Grass -> {
      case attacker {
        Bug -> 2.0
        Electric -> 0.5
        Fire -> 2.0
        Flying -> 2.0
        Grass -> 0.5
        Ground -> 0.5
        Ice -> 2.0
        Poison -> 2.0
        Water -> 0.5
        _ -> 1.0
      }
    }
    Ice -> {
      case attacker {
        Fighting -> 2.0
        Fire -> 2.0
        Ice -> 0.5
        Rock -> 2.0
        Steel -> 2.0
        _ -> 1.0
      }
    }
    Fighting -> {
      case attacker {
        Bug -> 0.5
        Dark -> 0.5
        Fairy -> 2.0
        Flying -> 2.0
        Psychic -> 2.0
        Rock -> 0.5
        _ -> 1.0
      }
    }
    Poison -> {
      case attacker {
        Bug -> 0.5
        Fairy -> 0.5
        Fighting -> 0.5
        Grass -> 0.5
        Ground -> 2.0
        Poison -> 0.5
        Psychic -> 2.0
        _ -> 1.0
      }
    }
    Ground -> {
      case attacker {
        Electric -> 0.0
        Grass -> 2.0
        Ice -> 2.0
        Poison -> 0.5
        Rock -> 0.5
        Water -> 2.0
        _ -> 1.0
      }
    }
    Flying -> {
      case attacker {
        Bug -> 0.5
        Electric -> 2.0
        Fighting -> 0.5
        Grass -> 0.5
        Ground -> 0.0
        Ice -> 2.0
        Rock -> 2.0
        _ -> 1.0
      }
    }
    Psychic -> {
      case attacker {
        Bug -> 2.0
        Dark -> 2.0
        Fighting -> 0.5
        Ghost -> 2.0
        Psychic -> 0.5
        _ -> 1.0
      }
    }
    Bug -> {
      case attacker {
        Fighting -> 0.5
        Fire -> 2.0
        Flying -> 2.0
        Grass -> 0.5
        Ground -> 0.5
        Rock -> 2.0
        _ -> 1.0
      }
    }
    Rock -> {
      case attacker {
        Fighting -> 2.0
        Fire -> 0.5
        Flying -> 0.5
        Grass -> 2.0
        Ground -> 2.0
        Normal -> 0.5
        Poison -> 0.5
        Steel -> 2.0
        Water -> 2.0
        _ -> 1.0
      }
    }
    Ghost -> {
      case attacker {
        Bug -> 0.5
        Dark -> 2.0
        Fighting -> 0.0
        Ghost -> 2.0
        Normal -> 0.0
        Poison -> 0.5
        _ -> 1.0
      }
    }
    Dragon -> {
      case attacker {
        Dragon -> 2.0
        Electric -> 0.5
        Fairy -> 2.0
        Fire -> 0.5
        Grass -> 0.5
        Ice -> 2.0
        Water -> 0.5
        _ -> 1.0
      }
    }
    Dark -> {
      case attacker {
        Bug -> 2.0
        Dark -> 0.5
        Fairy -> 2.0
        Fighting -> 2.0
        Ghost -> 0.5
        Psychic -> 0.0
        _ -> 1.0
      }
    }
    Steel -> {
      case attacker {
        Bug -> 0.5
        Dragon -> 0.5
        Fairy -> 0.5
        Fighting -> 2.0
        Fire -> 2.0
        Flying -> 0.5
        Grass -> 0.5
        Ground -> 2.0
        Ice -> 0.5
        Normal -> 0.5
        Poison -> 0.0
        Psychic -> 0.5
        Rock -> 0.5
        Steel -> 0.5
        _ -> 1.0
      }
    }
    Fairy -> {
      case attacker {
        Bug -> 0.5
        Dark -> 0.5
        Dragon -> 0.0
        Fighting -> 0.5
        Poison -> 2.0
        Steel -> 2.0
        _ -> 1.0
      }
    }
  }
}
