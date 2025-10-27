# syntax = docker/dockerfile:1.2

# choose your Python version
ARG PYTHON_VERSION=3.11

FROM python:${PYTHON_VERSION}-bookworm AS builder
COPY --from=ghcr.io/astral-sh/uv:0.9.5 /uv /bin/uv

ENV \
    # do not buffer python output at all
    PYTHONUNBUFFERED=1 \
    # do not write `__pycache__` bytecode
    PYTHONDONTWRITEBYTECODE=1 \
    # compile bytecode for better runtime performance
    UV_COMPILE_BYTECODE=1 \
    # improve performance across builds by caching
    UV_LINK_MODE=copy

WORKDIR /app

RUN --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=uv.lock,target=uv.lock \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    uv sync \
    --frozen \
    --no-install-workspace \
    --no-editable \
    --no-dev

ADD . /app

RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --locked --no-editable

FROM python:${PYTHON_VERSION}-bookworm AS runtime

ENV PATH="/app/.venv/bin:$PATH"

COPY --from=builder /app/.venv /app/.venv

WORKDIR /app

ENTRYPOINT [ "python", "-m", "my_app.main"]
