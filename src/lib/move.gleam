import lib/element.{type Element}

pub type Move {
  Move(name: String, element: Element)
  WithPrecondition(move: Move, condition: Nil)
  WithApplicability(move: Move, condition: Nil)
}

pub fn new(name: String) -> Move {
  Move(name:, element: element.Normal)
}

pub fn with_element(move: Move, element: Element) -> Move {
  case move {
    Move(name, _) -> Move(name, element)
    WithPrecondition(move, condition) ->
      WithPrecondition(with_element(move, element), condition)
    WithApplicability(move, condition) ->
      WithApplicability(with_element(move, element), condition)
  }
}

pub fn with_precondition(move: Move, precondition: Nil) -> Move {
  case move {
    Move(name, element) -> WithPrecondition(Move(name, element), precondition)
    WithPrecondition(move, _) ->
      WithPrecondition(with_precondition(move, precondition), precondition)
    WithApplicability(move, _) ->
      WithApplicability(with_precondition(move, precondition), precondition)
  }
}
