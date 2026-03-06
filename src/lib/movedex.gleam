import lib/element
import lib/move

pub fn pound() -> move.Move {
  move.new("Pound")
  |> move.with_element(element.Normal)
}

pub fn scratch() -> move.Move {
  move.new("Scratch")
  |> move.with_element(element.Normal)
}
