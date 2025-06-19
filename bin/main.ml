open Js_of_ocaml
module Html = Dom_html

let bounds = 2.0
let max_iterations = 100.0
let canvas_width = 960.0
let canvas_height = 960.0
let centerX = ref 0.0
let centerY = ref 0.0
let scale = ref 1.0
let color_adjusts = [ 50.0; 100.0; 150.0; 200.0; 250.0; 300.0; 350.0; 400.0 ]

let calculate_convergence (c : Complex_number.t ref) =
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

let color_generator (counter_value : float) : float =
  let magical_value = Float.sqrt (counter_value /. max_iterations) *. 200.0 in
  let adjust =
    List.nth color_adjusts
      (Int.rem (int_of_float magical_value) (List.length color_adjusts))
  in
  float_of_int (Int.rem (int_of_float (adjust -. magical_value)) 255)

let get_color ((counter, within_boundaries) : float ref * bool ref) =
  if !within_boundaries then (0.0, 0.0, 0.0)
  else if !counter > 1.0 then
    let random_color value = color_generator (abs_float (!counter -. value)) in
    (random_color 5.0, random_color 80.0, random_color 100.0)
  else (max_iterations, max_iterations, max_iterations)

let draw (canvas : Html.canvasElement Js.t) =
  let () =
    canvas##.width := int_of_float canvas_width;
    canvas##.height := int_of_float canvas_height
  in
  let ctx = canvas##getContext Dom_html._2d_ in

  for row = 1 to int_of_float canvas_height do
    for col = 1 to int_of_float canvas_width do
      let real =
        (float_of_int row -. (canvas_width /. bounds))
        *. (2.0 *. bounds /. canvas_width)
        *. !scale
        +. !centerX
      in
      let imaginary =
        (float_of_int col -. (canvas_height /. bounds))
        *. (2.0 *. bounds /. canvas_height)
        *. !scale
        +. !centerY
      in

      let c = ref (Complex_number.create ~real ~imaginary) in

      let value = calculate_convergence c in

      let colors = ref (get_color value) in
      let r, g, b = !colors in

      let row = float_of_int row in
      let col = float_of_int col in
      ctx##.fillStyle := Js.string (Printf.sprintf "rgb(%f,%f,%f)" r g b);
      ctx##fillRect (Js.float row) (Js.float col) (Js.float 1.0) (Js.float 1.0)
    done
  done

let () =
  Html.getElementById_coerce "canvas" Html.CoerceTo.canvas |> function
  | None -> ()
  | Some canvas ->
      let () =
        let keyboard = ref Js.null in
        keyboard :=
          Js.some
            (Html.addEventListener Html.document Html.Event.keydown
               (Html.handler (fun e ->
                    match e##.keyCode with
                    | 37 ->
                        centerX := !centerX +. (!scale /. 2.0);
                        draw canvas;
                        Js._false
                    | 38 ->
                        centerY := !centerY +. (!scale /. 2.0);
                        draw canvas;
                        Js._false
                    | 39 ->
                        centerX := !centerX -. (!scale /. 2.0);
                        draw canvas;
                        Js._false
                    | 40 ->
                        centerY := !centerY -. (!scale /. 2.0);
                        draw canvas;
                        Js._false
                    | 187 ->
                        scale := 0.5 *. !scale;
                        draw canvas;
                        Js._false
                    | 189 ->
                        scale := 2.0 *. !scale;
                        draw canvas;
                        Js._false
                    | _ -> Js._true))
               Js._true);
        draw canvas
      in
      print_string "Fractaml"
