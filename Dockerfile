FROM ghcr.io/astral-sh/uv:python3.13-alpine

ENV UV_SYSTEM_PYTHON=1

WORKDIR /app

COPY requirements.txt .

RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*
RUN uv pip install -r requirements.txt

COPY . .

EXPOSE 80

CMD [ "uv", "run", "sanic", "-H", "0.0.0.0", "-p", "80", "src.main" ]
