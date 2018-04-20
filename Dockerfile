FROM burgerdev/ocaml-build:4.06-0 as build

RUN opam install cohttp-lwt-unix

# 17.12 syntax
ADD --chown=opam:nogroup . repo

RUN cd repo && echo "(-cclib -static)" >bin/link_flags && \
    eval `opam config env` && jbuilder build

FROM scratch

COPY --from=build /home/opam/repo/_build/default/bin/main.exe \
    /home/opam/repo/*LICENSE \
    /

USER 1

EXPOSE 8080

ENTRYPOINT ["/main.exe"]
CMD ["--bind", "0.0.0.0"]
