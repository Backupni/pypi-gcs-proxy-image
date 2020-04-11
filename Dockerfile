FROM python:3.8.2-buster

COPY requirements.txt /

RUN set -Eeuxo pipefail \
    && apt update \
    && apt full-upgrade -y \
    && python3 -m pip install --no-cache-dir --upgrade --upgrade-strategy='eager' \
        'setuptools' \
        'pip' \
        'wheel' \
    && python3 -m pip install --no-cache-dir -r 'requirements.txt' --require-hashes \
    && rm 'requirements.txt' \
    && apt -y autoremove \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

COPY ./app /app

CMD ["uvicorn", "app.proxy:app", "--host", "0.0.0.0", "--port", "8080"]
