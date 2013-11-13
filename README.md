# grunt-city

* grunt template

## lang

* stylus (css)
* coffee (js)
* jade (html)

## usage

```
./server -h
```

```
Usage: server [options]

> fallback-able simple static server for debug

Options:
  -p, --port  [INT]  server port (3000)
  -m, --mode  [STR]  dev or pro (dev)
  -i, --index [STR]  fallback file (index.html)
  -g, --grunt        spawn grunt watch process
  -h, --help         show this message and exit

Example:
  ./server -p 3000 -m dev -i index.html -g
```

## install

```
npm -g install grunt-cli
npm install
```

## build

```
grunt build
```

## watch

```
grunt watch
```



