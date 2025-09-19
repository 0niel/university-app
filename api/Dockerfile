FROM dart:stable AS build

WORKDIR /app

# Resolve app dependencies.
COPY pubspec.yaml pubspec.lock* ./
COPY packages ./packages
RUN dart pub get

# Build server with dart_frog
COPY . ./

RUN dart pub global activate dart_frog_cli \
 && dart pub global run dart_frog_cli:dart_frog build \
 && dart pub get --offline \
 && dart compile exe build/bin/server.dart -o build/bin/server

# Runtime stage
FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/build/bin/server /app/bin/server
COPY --from=build /app/build/public /public

ENV DART_VM_OPTIONS="--old_gen_heap_size=256"
CMD ["/app/bin/server"]
