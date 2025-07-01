module Canvas = Browser.Canvas

let bounds = 2.0
let maxIterations = 100
let canvasWidth = 960
let canvasHeight = 960
let centerX = ref(0.0)
let centerY = ref(0.0)
let scale = ref(1.0)
let colorAdjusts = [50.0, 100.0, 150.0, 200.0, 250.0, 300.0, 350.0, 400.0]

let calculateConvergence = (c: Complex.t): (int, bool) => {
  let z: Complex.t = {re: 0.0, im: 0.0}
  let counter = 0
  let withinBoundaries = true

  let rec aux = (z, counter, withinBoundaries) => {
    if counter < maxIterations && withinBoundaries {
      let zSquare = Complex.mul(z, z)
      let newZ = Complex.add(zSquare, c)
      let newCounter = counter + 1
      let newWithinBoundaries = Complex.norm(newZ) > bounds ? false : withinBoundaries

      aux(newZ, newCounter, newWithinBoundaries)
    } else {
      (counter, withinBoundaries)
    }
  }

  aux(z, counter, withinBoundaries)
}

let colorGenerator = (counter: int): int => {
  let magicalValue = Math.sqrt(counter->Int.toFloat /. maxIterations->Int.toFloat) *. 200.0

  let adjust =
    colorAdjusts->Array.getUnsafe(mod(magicalValue->Float.toInt, colorAdjusts->Array.length))

  mod((adjust -. magicalValue)->Float.toInt, 255)
}

let getColor = ((counter, withinBoundaries): (int, bool)): (int, int, int) => {
  if withinBoundaries {
    (0, 0, 0)
  } else if counter > 1 {
    let randomColor = value => colorGenerator(counter - value)
    (randomColor(5), randomColor(80), randomColor(100))
  } else {
    (maxIterations, maxIterations, maxIterations)
  }
}

let draw = (context: Canvas.context2d): unit => {
  for row in 0 to canvasHeight - 1 {
    for col in 0 to canvasWidth - 1 {
      let real =
        (row->Int.toFloat -. canvasWidth->Int.toFloat /. bounds) *.
        (2.0 *. bounds /. canvasWidth->Int.toFloat) *.
        scale.contents +. centerX.contents

      let imaginary =
        (col->Int.toFloat -. canvasHeight->Int.toFloat /. bounds) *.
        (2.0 *. bounds /. canvasHeight->Int.toFloat) *.
        scale.contents +. centerY.contents

      let c: Complex.t = {re: real, im: imaginary}

      let value = calculateConvergence(c)

      let colors = getColor(value)
      let (r, g, b) = colors

      let row = row->Int.toFloat
      let col = col->Int.toFloat

      context->Canvas.fillStyle(`rgb(${r->Int.toString},${g->Int.toString},${b->Int.toString})`)
      context->Canvas.fillRect(~x=row, ~y=col, ~width=1.0, ~height=1.0)
    }
  }
}

Browser.document
->Browser.querySelector("canvas")
->Option.flatMap(Canvas.fromElement)
->Option.forEach(canvas => {
  canvas->Canvas.setWidth(canvasWidth)
  canvas->Canvas.setHeight(canvasHeight)

  canvas
  ->Canvas.getContext2d
  ->Option.forEach(draw)
})
