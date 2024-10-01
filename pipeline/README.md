# Pipeline

Flowmotion's ML pipeline

## Setup

- Install `pip` modules

```sh
pip install -r requirements.txt
```

- Setup [Google Application Default credentials](https://cloud.google.com/docs/authentication#service-accounts),
  which is needed to is needed to authenticate with the Firestore
  (eg. by setting `GOOGLE_APPLICATION_CREDENTIALS` env var.) <a id="pipeline-credentials"></a>

## Usage

Running the ML PIpeline:

2. Run Pipeline

```sh
python pipeline.py
```

## Contributing

Before pushing, ensure that you:

1. Format & Lint code

```sh
black . && isort . && ruff .
```

2. Run unit tests.

```sh
pytest -m "not integration"
```

3. Run integration tests. Requires [GCP credentials](#pipeline-credentials).

```sh
pytest -m integration
```

> A `makefile` is provided to make this easier. Just `make`.
