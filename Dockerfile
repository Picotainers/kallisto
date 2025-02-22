FROM debian:bullseye-slim AS builder

RUN apt-get update && \
   apt-get install -y git make gcc zlib1g-dev upx-ucl cmake g++ 


RUN git clone https://github.com/pachterlab/kallisto && \
   \    
  cd kallisto && \
  sh gen_release.sh linux && \
  strip --strip-all release/kallisto/kallisto && \
  upx release/kallisto/kallisto && \
  mkdir -p /data



# Use a distroless base image
FROM gcr.io/distroless/base

# Copy the kallisto binary from the builder image
COPY --from=builder /kallisto/release/kallisto/kallisto /usr/local/bin/kallisto
COPY --from=builder /data /data
WORKDIR /data
# Set the entrypoint
ENTRYPOINT ["/usr/local/bin/kallisto"]
