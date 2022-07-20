open Js_of_ocaml
module Html = Dom_html

let conversion_threshold = 16.0
let max_iterations = 100
let canvas_width = 960
let canvas_height = 960

let scale (init_x, init_y) (end_x, end_y) value =
  end_x +. ((value -. init_x) *. (end_y -. end_x) /. (init_y -. init_x))

let has_converged complex_number =
  let real, imaginary = Complex_number.to_tuple complex_number in
  (real *. real) +. (imaginary *. imaginary) > conversion_threshold

let () =
  Html.getElementById_coerce "canvas" Html.CoerceTo.canvas |> function
  | None -> ()
  | Some canvas ->
      let () =
        canvas##.width := canvas_width;
        canvas##.height := canvas_height
      in
      let ctx = canvas##getContext Dom_html._2d_ in

      for row = 1 to canvas_height do
        for col = 1 to canvas_width do
          let real =
            scale
              (0.0, float_of_int canvas_width)
              (-0.8, 0.5) (float_of_int row)
          in
          let imaginary =
            scale
              (0.0, float_of_int canvas_width)
              (-0.8, 0.5) (float_of_int col)
          in

          let z = ref (Complex_number.create ~real:0.0 ~imaginary:0.0) in

          let c = ref (Complex_number.create ~real ~imaginary) in

          let counter = ref 0 in

          let should_break = ref false in

          let () =
            while !counter < max_iterations && not !should_break do
              let z_square = Complex_number.square !z in
              Complex_number.(z := z_square + !c);
              if has_converged !z then should_break := true
              else counter := !counter + 1
            done
          in

          let color =
            scale
              (0.0, float_of_int max_iterations)
              (0.0, 1.0) (float_of_int !counter)
          in
          let color = scale (0.0, 1.0) (0.0, 255.0) (sqrt color) in
          let color = if !counter = max_iterations then 0.0 else color in

          let row = float_of_int row in
          let col = float_of_int col in
          ctx##.fillStyle :=
            Js.string (Printf.sprintf "rgb(%f,%f,%f)" color color color);
          ctx##fillRect row col 1.0 1.0
        done
      done
