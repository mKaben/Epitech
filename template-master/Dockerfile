FROM pandoc/latex:2.8.1 AS gpp_build

RUN apk update && apk --no-cache add -U make curl gcc libc-dev libc6-compat
RUN wget -c https://github.com/logological/gpp/releases/download/2.25/gpp-2.25.tar.bz2 && \
    tar jxf gpp-2.25.tar.bz2 && cd gpp-2.25 && ./configure && make && cp src/gpp /usr/bin/

FROM pandoc/latex:2.8.1 AS base
MAINTAINER Jonathan Nau <jonathan1.nau@epitech.eu>

COPY --from=gpp_build /usr/bin/gpp /usr/bin/gpp
COPY . /template
RUN apk add --no-cache bash && /template/install-tex-packages.sh && rm /template/install-tex-packages.sh && for d in $(find /template -type d); do chmod 777 $d; done

WORKDIR /pdf

ENTRYPOINT [ "/template/entrypoint.sh" ]
