# JSON5toJSON

A small command line tool to convert [JSON5](https://github.com/json5/json5) to [JSON](https://www.json.org/json-en.html). Runs on macOS 12 (Monterey).



### Installation

Install using [Mint](https://github.com/yonaskolb/Mint).
```sh
$ mint install auramagi/json5tojson
```

### Usage

- Convert JSON5 file and print to standard output
  ```sh
  $ json5tojson INPUT.json
  ```

- Convert JSON5 file and write output to another file
  ```sh
  $ json5tojson INPUT.json OUTPUT.json
  ```

- Same, but with pretty printing
  ```sh
  $ json5tojson -p INPUT.json OUTPUT.json
  ```

Run `json5tojson --help` to see all options.
