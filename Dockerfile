FROM ocamlpro/ocaml:4.14
LABEL org.opencontainers.image.authors="Christoph Knittel <ck@cca.io>"
LABEL org.opencontainers.image.description="Alpine-based Docker image for building statically linked ReScript binaries."

USER ocaml
RUN opam switch create ocaml-system
RUN opam update
RUN opam install dune cppo=1.6.9 js_of_ocaml-compiler=4.0.0 ocamlformat=0.22.4 ounit2=2.2.6 reanalyze=2.23.0

USER root

# Needed for ninja compilation
RUN apk add g++ python3
