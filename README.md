# Example of uv workspace

This repository wants to be a minimalistic example of [uv _workspace_](https://docs.astral.sh/uv/concepts/projects/workspaces/), hosting an app (`/src/my_app`) and a library (`/packages/my_lib`) it depends on. Each _workspace member_ can be either an application or a library, and there can be multiple of them: each of them has its own `pyproject.toml`, but there's a single, global `uv.lock` lockfile in the root directory.

What is included in this example:

- basic `uv` workspace layout, including `tests`
- linting with `ruff` (optional)
- `Dockerfile` (+ `.dockerignore`) to build a Docker image for `my_app` (optional)
- `Makefile`s to streamline the most common operations (optional)

## Basic `uv` operations

### Creating virtual environment

```shell
uv venv
```

This creates a virtual environment in the `.venv` directory, so you can point your IDE to it.

### Installing dependencies

```shell
uv sync                  # this will only install dependencies found in the current directory's pyproject.toml
uv sync --package my-lib # this will only install dependencies of my-lib
uv sync --all-packages   # this will install dependencies of all workspace members
```

### Linting

```shell
# note: these will only report issues, without fixing them
uv run ruff check
uv run ruff format --check

# note: these will report and fix issues
uv run ruff check --fix
uv run ruff format
```

### Running

```shell
uv run run.py
```

### Running tests

Note: `pytest` must be listed among the dependencies or the following command will not work.

```shell
uv run pytest tests
```

### Building package(s)

```shell
uv build                  # builds current project
uv build --package my-lib # builds a specific package
```

Build files are stored in the `dist/` directory.

### Publishing package(s)

```shell
uv publish # will publish all packages found in dist/
```

### Working with the lockfile

```shell
uv lock          # update lockfile (e.g. after manually changing pyproject.toml)
uv lock --check # check if it's still consistent with pyproject.toml
```
