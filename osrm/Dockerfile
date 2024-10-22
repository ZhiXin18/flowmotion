#
# Flowmotion
# ORSM with Custom Profile
# Dockerfile
#

ARG OSRM_VERSION=v5.27.1
FROM ghcr.io/project-osrm/osrm-backend:${OSRM_VERSION} AS base

# create non root user to run orsm
ARG USERNAME=orsm
ARG USER_UID=1000
ARG USER_GID=$USER_UID
RUN groupadd --gid $USER_GID $USERNAME \
   && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME 

# setup project directory
RUN mkdir -p /app && chown ${USERNAME} /app
WORKDIR /app

FROM base AS build
# install apt packages
RUN apt-get update \
   && apt-get install -y curl \
   && rm -rf /var/lib/apt/lists/*

# download OSRM source code
ARG OSRM_VERSION=5.27.1
RUN curl -L https://github.com/Project-OSRM/osrm-backend/archive/refs/tags/v${OSRM_VERSION}.tar.gz -o osrm-backend.tgz \
   && tar -xzf osrm-backend.tgz

# download tagged map data
COPY map_tagged.osm.pbf map.osm.pbf
# copy custom profile for processing
COPY congestion_profile.lua osrm-backend-${OSRM_VERSION}/profiles/
# OSRM map data preprocessing for multi-level dijkstra (MLD) routing
RUN osrm-extract -p osrm-backend-${OSRM_VERSION}/profiles/congestion_profile.lua map.osm.pbf \
   && osrm-partition map.osrm \
   && osrm-customize map.osrm

# build runtime container free of build dependencies
FROM build AS runtime
COPY --from=build /app/map.osrm* /app/
USER ${USERNAME}
CMD [ "osrm-routed", "--algorithm=MLD", "/app/map.osrm" ]
