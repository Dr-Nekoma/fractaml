(lang dune 3.19)

(name fractaml)

(generate_opam_files true)

(package
 (name fractaml)
 (synopsis "A short description of my awesome project")
 (maintainers "youremail@example.com")
 (depends
  (ocaml
   (and
    (>= 5.3.0)
    (< 5.4.0)))
  (dune
   (and
    (>= 3.19.1)
    (< 3.20.0)))
  (js_of_ocaml
   (and
    (>= 6.0.1)
    (< 6.1.0)))
  (js_of_ocaml-ppx
   (and
    (>= 6.0.1)
    (< 6.1.0)))
  ocaml-lsp-server
  ocamlformat)
 (allow_empty))
