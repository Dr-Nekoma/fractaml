open Js_of_ocaml
module Html = Dom_html

let bounds = 2.0
let max_iterations = 100.0
let canvas_width = 960.0
let canvas_height = 960.0

let scale (init_x, init_y) (end_x, end_y) value =
  end_x +. ((value -. init_x) *. (end_y -. end_x) /. (init_y -. init_x))

let calculate_convergence (c: Complex_number.t ref) =
  let z = ref (Complex_number.create ~real:0.0 ~imaginary:0.0) in

  let counter = ref 0.0 in

  let within_boundaries = ref true in

  let () =
    while !counter < max_iterations && !within_boundaries do
      let z_square = Complex_number.square !z in
      Complex_number.(z := z_square + !c);
      counter := !counter +. 1.0;
      if Complex_number.magnitude !z > bounds then within_boundaries := false
    done
  in

  (counter, within_boundaries)

let get_color ((counter, within_boundaries): (float ref * bool ref)) =
  if !within_boundaries then
    0.0, 0.0, 0.0
  else if (!counter > 1.0) then
    float_of_int (Int.rem (int_of_float (170.0 +. 230.0 -. ((Float.sqrt (!counter /. max_iterations)) *. 200.0))) 255), 80.0, 110.0
  else
    max_iterations, max_iterations, max_iterations

let () =
  Html.getElementById_coerce "canvas" Html.CoerceTo.canvas |> function
  | None -> ()
  | Some canvas ->
      let () =
        canvas##.width := int_of_float canvas_width;
        canvas##.height := int_of_float canvas_height
      in
      let ctx = canvas##getContext Dom_html._2d_ in

      for row = 1 to int_of_float canvas_height do
        for col = 1 to int_of_float canvas_width do
          let real = ((float_of_int row) -. (canvas_width /. bounds)) *. (2.0 *. bounds /. canvas_width) in
          let imaginary = ((float_of_int col) -. (canvas_height /. bounds)) *. (2.0 *. bounds /. canvas_height) in 

          let c = ref (Complex_number.create ~real ~imaginary) in

          let value = calculate_convergence(c) in

          let colors = ref (get_color value) in
          let r, g, b = !colors in

          let row = float_of_int row in
          let col = float_of_int col in
          ctx##.fillStyle :=
            Js.string (Printf.sprintf "rgb(%f,%f,%f)" r g b);
          ctx##fillRect row col 1.0 1.0
        done
      done
