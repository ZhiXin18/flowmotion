#
# Flowmotion
# OSRM with Custom Profile
# Dockerfile
#

ARG OSRM_VERSION=v5.27.1
FROM ghcr.io/project-osrm/osrm-backend:${OSRM_VERSION} AS base

# create non root user to run osrm
ARG USERNAME=osrm
ARG USER_UID=1000
ARG USER_GID=$USER_UID
RUN groupadd --gid $USER_GID $USERNAME \
   && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME 

# setup project directory
RUN mkdir -p /app && chown ${USERNAME} /app
WORKDIR /app

FROM base AS build
# install apt ackages
RUN apt-get update \
   && apt-get install -y curl osmium-tool \
   && rm -rf /var/lib/apt/lists/*

# TODO: change to github archive URL
# download map 
RUN curl https://download.geofabrik.de/asia/malaysia-singapore-brunei-latest.osm.pbf -o map.osm.pbf
# extract bounding box from map to limit map data processed
# singapore bounding box
ARG MAP_BOUNDING_BOX=103.590088,1.210466,104.037094,1.475438
RUN osmium extract --bbox=${MAP_BOUNDING_BOX} map.osm.pbf -o bbox.osm.pbf \
   && mv -f bbox.osm.pbf map.osm.pbf

# OSRM map data preprocessing for multi-level dijkstra (MLD) routing
ARG OSRM_VERSION=5.27.1
RUN curl -L https://github.com/Project-OSRM/osrm-backend/archive/refs/tags/v${OSRM_VERSION}.tar.gz -o osrm-backend.tgz \
   && tar -xzf osrm-backend.tgz
RUN osrm-extract -p osrm-backend-${OSRM_VERSION}/profiles/car.lua map.osm.pbf \
   && osrm-partition map.osrm \
   && osrm-customize map.osrm

FROM build AS runtime
COPY --from=build /app/map.osrm* /app/
USER ${USERNAME}

CMD [ "osrm-routed", "--algorithm=MLD", "map.osrm " ]
