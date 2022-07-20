type t = { real : float; imaginary : float }

let create ~real ~imaginary = { real; imaginary }
let to_tuple { real; imaginary } = (real, imaginary)

let add { real = r1; imaginary = i1 } { real = r2; imaginary = i2 } =
  { real = r1 +. r2; imaginary = i1 +. i2 }

let sub { real = r1; imaginary = i1 } { real = r2; imaginary = i2 } =
  { real = r1 -. r2; imaginary = i1 -. i2 }

let square { real; imaginary } =
  {
    real = (real ** 2.0) -. (imaginary ** 2.0);
    imaginary = 2.0 *. real *. imaginary;
  }

let ( + ) = add
