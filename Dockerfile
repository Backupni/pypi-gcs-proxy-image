FROM python:3.8.2-alpine3.11

COPY requirements.txt /

RUN set -ex \
    && apk upgrade --no-cache \
    && apk add --upgrade --no-cache --virtual .build-deps  \
        'build-base' \
        'grpc-dev' \
        'linux-headers' \
    && apk add --upgrade --no-cache  \
        'grpc' \
    && python3 -m pip install --no-cache-dir --upgrade --upgrade-strategy='eager' \
        'setuptools' \
        'pip' \
        'wheel' \
    && python3 -m pip install --no-cache-dir -r 'requirements.txt' --require-hashes \
    && rm 'requirements.txt' \
    && apk del .build-deps

COPY ./app /app

CMD ["uvicorn", "app.proxy:app", "--host", "0.0.0.0", "--port", "8080"]
