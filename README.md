# grunt-city

* client side application template
* provides **build**, **lint**, **minify** and **livereload**

## install

```
git clone geta6/grunt-city myapp
cd myapp
npm -g i grunt-cli
npm i
```

## run

```
grunt
```

## usage

```
% grunt -h

Usage: grunt [options]

Options:
  -p, --port  [INT]  server port (3000)
  -m, --mode  [STR]  dev or pro (dev)
  -i, --index [STR]  fallback file (index.html)
  -h, --help         show this message and exit

Example:
  grunt -p 3000 -m dev -i index.html

Tasks:
  Build:
    coffee, stylus, jade
  Lint:
    coffeelint, csslint
  Minify:
    uglify, cssmin, htmlmin
  Server:
    connect, watch
  Phony:
    default - launch server after build
    build   - execute all tasks without server
```

## options

* port
  * static server port
  * assets server on `localhost` with port `3000` default
* mode
  * mode `dev` serves un-minified assets, default
  * mode `pro` serves minified assets
* index
  * static server fallback defaults to `index.html`

## server core

request to unexists path, fallback to index file.

```coffee
# route = req.url
# index = path.resolve 'public', 'index.html'

fs.exists route, (exist) ->
  fs.stat route, (err, stat) ->
    if exist and stat.isFile()
      return fs.createReadStream(route).pipe(res)
    return fs.createReadStream(index).pipe(res)
```

## livereload

* install [livereload extensions](http://feedback.livereload.com/knowledgebase/articles/86242-how-do-i-install-and-use-the-browser-extensions-)

## caution

* static server is only for preview
* is not compatible for production environment

## license

MIT
