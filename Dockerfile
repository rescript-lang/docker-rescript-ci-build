FROM alpine:3.19
LABEL org.opencontainers.image.authors="Christoph Knittel <ck@cca.io>"
LABEL org.opencontainers.image.description="Alpine-based Docker image for building statically linked ReScript binaries."

ARG GLIBC_VERSION=2.35-r1

# - python3 needed for ninja build
RUN apk add --no-cache bash gcc g++ git make opam python3 rsync

# Need to install glibc for ARM64, see https://github.com/actions/runner/issues/801#issuecomment-1705466496
RUN \
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
    && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk \
    && apk add glibc-${GLIBC_VERSION}.apk \
    && rm /etc/apk/keys/sgerrand.rsa.pub glibc-${GLIBC_VERSION}.apk

# We need to specify the OPAM dir explicitly as the GitHub Actions runner
# will set a different home directory when running in a container.
ENV OPAMROOT /root/.opam

RUN opam init -y --compiler=4.14.1 --disable-sandboxing

RUN opam install -y dune cppo=1.6.9 js_of_ocaml-compiler=4.0.0 ocamlformat=0.22.4 ounit2=2.2.6 reanalyze=2.23.0
