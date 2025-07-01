type document
type element
type canvasElement

@val
external document: document = "document"

@send @return(nullable)
external querySelector: (document, string) => option<element> = "querySelector"

@get
external tagName: element => string = "tagName"

module Canvas = {
  type context2d

  let fromElement = (element: element): option<canvasElement> =>
    if element->tagName->String.toLowerCase == "canvas" {
      Some(element->Obj.magic)
    } else {
      None
    }

  @set
  external setWidth: (canvasElement, int) => unit = "width"
  @set
  external setHeight: (canvasElement, int) => unit = "height"

  @send @return(nullable)
  external getContext2d: (canvasElement, @as("2d") _) => option<context2d> = "getContext"

  @set
  external fillStyle: (context2d, string) => unit = "fillStyle"

  @send
  external fillRect: (context2d, ~x: float, ~y: float, ~width: float, ~height: float) => unit =
    "fillRect"
}
