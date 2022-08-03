# fractmal

This is the [mandelbrot set](https://en.wikipedia.org/wiki/Mandelbrot_set) implemented in OCaml.

[![Second level of Recursion](./f1.png)]

[![Third level of Recursion](./f2.png)]

## External Dependencies

- [js_of_ocaml](https://opam.ocaml.org/packages/js_of_ocaml/)
- [js_of_ocaml-ppx](https://opam.ocaml.org/packages/js_of_ocaml-ppx/)
- [npm](https://nodejs.org/en/)

## How to run Fractmal

To execute the program, you first need `opam` to install the dependencies:

```bash
eval $(opam env)
opam install js_of_ocaml js_of_ocaml-ppx dune
```

To run:

```bash
dune build
npx serve

```

Go to `localhost:3000` to check out the fractal.

## Developers

- EduardoLR10
- ribeirotomas1904
- MMagueta

## Dr.Nekoma

Built live on [twitch](https://www.twitch.tv/drnekoma) and archived on [youtube](https://www.youtube.com/channel/UCMyzdYsPiBU3xoqaOeahr6Q)
