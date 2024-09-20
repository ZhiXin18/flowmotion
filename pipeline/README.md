# Pipeline

Flowmotion's ML pipeline

## Setup

```sh
pip install -r requirements.txt
```

## Usage

```sh
python pipeline.py
```

### Contributing
Before pushing, ensure that you:
1. Format & Lint code

```sh
black . && isort . && ruff .
```

3. Run tests

```sh
pytest
```

> A `makefile` is provided to make this easier. Just `make`.
