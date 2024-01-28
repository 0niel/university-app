ARG SERVER_VERSION
FROM nextcloud:${SERVER_VERSION}-fpm-alpine as nextcloud

WORKDIR /usr/src/nextcloud

RUN ./occ maintenance:install --admin-pass admin --admin-email admin@example.com
RUN ./occ config:system:set allow_local_remote_servers --value=true
RUN ./occ config:system:set trusted_domains 1 --value="*"

RUN ./occ app:disable password_policy
RUN OC_PASS="user1" ./occ user:add --password-from-env --display-name "User One" user1
RUN OC_PASS="user2" ./occ user:add --password-from-env --display-name "User Two" user2
RUN OC_PASS="demo" ./occ user:add --password-from-env --display-name "Demo" demo
RUN ./occ app:enable password_policy

RUN (sh /entrypoint.sh php -S 0.0.0.0:80 &) && \
    until curl -s -o /dev/null http://localhost/status.php; do true; done && \
    # Do not setup the demo user here
    for user in admin user1 user2; do curl -u "$user:$user" -H "ocs-apirequest: true" -s -o /dev/null http://localhost/ocs/v2.php/cloud/user; done

COPY static /usr/src/nextcloud/static

ENV PHP_CLI_SERVER_WORKERS=10
CMD ["php", "-S", "0.0.0.0:80"]

FROM alpine:latest@sha256:c5b1261d6d3e43071626931fc004f70149baeba2c8ec672bd4f27761f8e1ad6b as apps
RUN apk add curl

FROM apps as news
ARG NEWS_URL
RUN curl -L "$NEWS_URL" | tar -xz -C /

FROM apps as notes
ARG NOTES_URL
RUN curl -L "$NOTES_URL" | tar -xz -C /

FROM apps as uppush
ARG UPPUSH_URL
RUN curl -L "$UPPUSH_URL" | tar -xz -C /

FROM apps as spreed
ARG SPREED_URL
RUN curl -L "$SPREED_URL" | tar -xz -C /

FROM nextcloud

COPY --from=news /news /usr/src/nextcloud/apps/news
RUN ./occ app:enable news

COPY --from=notes /notes /usr/src/nextcloud/apps/notes
RUN ./occ app:enable notes

COPY --from=uppush /uppush /usr/src/nextcloud/apps/uppush
RUN ./occ app:enable uppush

COPY --from=spreed /spreed /usr/src/nextcloud/apps/spreed
RUN ./occ app:enable spreed
RUN ./occ talk:turn:add turn,turns staticauth.openrelay.metered.ca:443 udp,tcp --secret openrelayprojectsecret
