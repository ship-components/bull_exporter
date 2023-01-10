#!/usr/bin/env bash
set -euo pipefail

# if EXPORTER_REDIS_URL isn't set and EXPORTER_REDIS_URL_FILE is set, read URL from file
if [ -z "${EXPORTER_REDIS_URL-}" ] && [ -n "${EXPORTER_REDIS_URL_FILE-}" ] && [ -r "$EXPORTER_REDIS_URL_FILE" ]; then
    EXPORTER_REDIS_URL=$(cat $EXPORTER_REDIS_URL_FILE)
fi

url="${EXPORTER_REDIS_URL:-redis://localhost:6379/0}"
prefix="${EXPORTER_PREFIX:-bull}"
metric_prefix="${EXPORTER_STAT_PREFIX:-bull_queue_}"
queues="${EXPORTER_QUEUES:-}"
EXPORTER_AUTODISCOVER="${EXPORTER_AUTODISCOVER:-}"

flags=(
  --url "$url"
  --prefix "$prefix"
  --metric-prefix "$metric_prefix"
)

if [[ "$EXPORTER_AUTODISCOVER" != 0 && "$EXPORTER_AUTODISCOVER" != 'false' ]] ; then
  flags+=(-a)
fi

# shellcheck disable=2206
flags+=($queues)

exec node dist/src/index.js "${flags[@]}"
