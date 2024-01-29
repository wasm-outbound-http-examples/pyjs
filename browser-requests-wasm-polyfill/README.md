# Use requests-wasm-polyfill to send HTTP(s) requests from inside WASM

These instructions guide you along the process of building the 
[PyJS REPL](https://github.com/emscripten-forge/sample-python-repl)
with 
[`requests-wasm-polyfill`](https://github.com/emscripten-forge/requests-wasm-polyfill) 
plugin installed.

## Instructions for this devcontainer

Tested with requests-wasm-polyfill 0.3.0, pyjs 1.1.0, empack 3.3.1 .

Following instructions are partially based on [this doc](https://github.com/emscripten-forge/sample-python-repl/blob/main/README.md#usage).

### Preparation

1. Open this repo in devcontainer, e.g. using Github Codespaces.
   Type or copy/paste following commands to devcontainer's terminal.

### Building

1. `cd` into the folder of this example:

```sh
cd browser-requests-wasm-polyfill
```

2. Clone `emscripten-forge/sample-python-repl` repo :

```sh
git clone --depth=1 https://github.com/emscripten-forge/sample-python-repl
```

3. `cd` into the folder of sample-python-repl:

```sh
cd sample-python-repl
```

4. Create new Mamba environment named `pyjs-build-env` to build the REPL example:

```sh
micromamba create -n pyjs-build-env -f build-environment.yaml -y
```

This will install into the `pyjs-build-env` lots of packages, including Python and empack.

4. Activate the `pyjs-build-env` environment. In Codespace activation is a bit tricky, therefore it needs several steps.
   Firstly, initialize the `.bashrc` by:

```sh
micromamba shell init --shell=bash
```

5. Secondly, Open an additional terminal tab using the `bash` shell.

6. Thirdly, In the newly opened terminal tab, eventually activate the `pyjs-build-env` environment:

```sh
cd browser-requests-wasm-polyfill/sample-python-repl

micromamba activate pyjs-build-env 
```

The command line's prompt should indicate the active environment.

7. Add the `requests-wasm-polyfill` dependency to REPL's web package:

```sh
echo '  - requests-wasm-polyfill' >> web-environment.yaml
```

8. Build the web package:

```sh
python3 build.py --env-name=web-package-build-env
```

The `build.py` script will create new Mamba environment using `web-environment.yaml`, and perform the build process there.
After that, `build.py` will run `empack`, and put the result in `build` subdirectory.

9. Patch the `requests-wasm-polyfill` to allow it run in the main browser frame.
  Need to comment out 
  [this line](https://github.com/emscripten-forge/requests-wasm-polyfill/blob/5a66b884cf05cf4e20d42f1fd8f8b005d843ecc6/requests/api.py#L36).
  This little patch is enough for demonstration purposes.

In the case the patch is not applied, the HTTP request will fail with this error:
`Error: Failed to set the 'responseType' property on 'XMLHttpRequest': The response type cannot be changed for synchronous requests made from a document.`

The following command runs the bash script which extracts the requests-wasm-polyfill's archive, patches the `api.py`, and re-assembles the archive back:

```sh
bash ../patch-requests-wasm-polyfill-inside-archive.sh
```

### Test with browser

1. Run simple HTTP server to temporarily publish project to Web, serving the content from `build` subdirectory:

```sh
python3 -m http.server --directory build
```

Codespace will show you "Open in Browser" button. Just click that button or
obtain web address from "Forwarded Ports" tab.

2. As REPL is loaded into browser (about 21 MB) and `...done` is displayed in the bottom frame, insert the following code in the 
REPL's code frame:

```python
import requests

r = requests.get('https://httpbin.org/anything')
result = r.text
print(result)

```

3. Click `Run` button in the REPL and see the results in the bottom REPL's frame.

Alternatively you can patch the 
[`script.js`](https://github.com/emscripten-forge/sample-python-repl/blob/ff461324bbc892280e4219305308aaf5c52b8197/page/script.js#L20)
in a manner like 
[in demo](https://github.com/wasm-outbound-http-examples/pyjs/blob/596d23d2dcd930ec7025eb734feaaffa478c13f5/requests-wasm-polyfill/script.js#L20-L29) 
and re-run the `build.py`. 

### Finish

Perform your own experiments if desired.
