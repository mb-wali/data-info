FROM clojure:openjdk-17-lein-alpine

WORKDIR /usr/src/app

RUN apk add --no-cache git

RUN ln -s "/opt/openjdk-17/bin/java" "/bin/data-info"

COPY project.clj /usr/src/app/
RUN lein deps

COPY conf/main/logback.xml /usr/src/app/
COPY . /usr/src/app

# copy config file 
COPY data-info.properties /etc/iplant/de/data-info.properties

RUN lein uberjar && \
    cp target/data-info-standalone.jar .

ENTRYPOINT ["data-info", "-Dlogback.configurationFile=/etc/iplant/de/logging/data-info-logging.xml", "-cp", ".:data-info-standalone.jar", "data_info.core"]
# CMD ["--help"]

ARG git_commit=unknown
ARG version=unknown
ARG descriptive_version=unknown

LABEL org.cyverse.git-ref="$git_commit"
LABEL org.cyverse.version="$version"
LABEL org.cyverse.descriptive-version="$descriptive_version"
LABEL org.label-schema.vcs-ref="$git_commit"
LABEL org.label-schema.vcs-url="https://github.com/cyverse-de/data-info"
LABEL org.label-schema.version="$descriptive_version"


# build 
# docker build -t mbwali/data-info:latest .

# run
# docker run -it -p 60002:60002 mbwali/data-info:latest

# Config
# /etc/iplant/de/data-info.properties
