FROM obiba/opal:2.15

LABEL maintainer="The INESC TEC Team <coral@lists.inesctec.pt>"
LABEL system="Coral"

ENV OPAL_DIR=/usr/share/opal

COPY ./scripts/wait-for-it.sh /

COPY ./bin/ /opt/opal/bin/
RUN mkdir $OPAL_DIR/taxonomies

COPY ./docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["app"]
