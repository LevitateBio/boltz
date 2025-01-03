FROM nvidia/cuda:12.4.1-cudnn-runtime-ubuntu22.04 AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
  git \
  build-essential \
  python3 \
  python3-venv \
  python3-dev \
  && python3 -m venv /opt/venv \
  && . /opt/venv/bin/activate \
  && pip install --no-cache-dir --upgrade pip \
  && pip install --no-cache-dir boltz \
  && apt-get purge -y git build-essential \
  && apt-get autoremove -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

FROM nvidia/cuda:12.4.1-cudnn-runtime-ubuntu22.04

COPY --from=builder /opt/venv /opt/venv

RUN apt-get update && apt-get install -y --no-install-recommends \
  python3 \
  && apt-get autoremove -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV PATH="/opt/venv/bin:$PATH" \
  LANG=C.UTF-8 \
  PYTHONUNBUFFERED=1

WORKDIR /app

COPY LICENSE /app/LICENSE
COPY README.md /app/README.md
COPY examples /app/examples
COPY scripts /app/scripts
COPY docs /app/docs


ENTRYPOINT ["boltz"]
