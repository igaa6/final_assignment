fs = require 'fs'
url = require 'url'
util = require 'util'
path = require 'path'
http = require 'http'

PORT = 3000
MODE = 'dev'
INDEX = 'index.html'
BUILD = no

args = [].concat process.argv
while arg = args.shift()
  switch arg
    when '-m', '--mode' then MODE = args.shift()
    when '-p', '--port' then PORT = parseInt args.shift()
    when '-i', '--index' then INDEX = args.shift()
    when 'build' then BUILD = yes
    when '-h', '--help'
      console.log '''
        Usage: grunt [options]

        > grunt with fallback-able simple static server for debug

        Options:
          -p, --port  [INT]  server port (3000)
          -m, --mode  [STR]  dev or pro (dev)
          -i, --index [STR]  fallback file (index.html)
          -h, --help         show this message and exit

        Example:
          grunt -p 3000 -m dev -i index.html
        '''
      process.exit 1

MODE = 'dev' unless MODE in ['dev', 'pro']
ROOT = if MODE is 'dev' then 'dist' else 'public'
INDEX = INDEX.slice 1 while '/' is INDEX.slice 0, 1

index = path.resolve ROOT, INDEX

unless fs.existsSync index
  console.error "server: #{ROOT}/#{INDEX} not found"
  process.exit 1

print = (exist, req, res) ->
  status = switch yes
    when res.statusCode < 300 then "\x1b[32m#{res.statusCode}\x1b[0m"
    when res.statusCode < 400 then "\x1b[36m#{res.statusCode}\x1b[0m"
    when res.statusCode < 500 then "\x1b[32m#{res.statusCode}\x1b[0m"
    else                           "\x1b[31m#{res.statusCode}\x1b[0m"
  method = "\x1b[37m#{req.method}\x1b[0m"
  fail = "\x1b[35m*\x1b[0m"
  done = "\x1b[32m^\x1b[0m"
  process.stdout.write "#{new Date().toLocaleTimeString()} | #{if exist then done else fail} #{method} #{status} #{req.url}\n"

serve = (route, req, res) ->
  fs.exists route, (exist) ->
    fs.stat route, (err, stat) ->
      if exist and stat.isFile()
        print exist, req, res
        return fs.createReadStream(route).pipe(res)
      print exist, req, res
      return fs.createReadStream(index).pipe(res)

unless BUILD
  console.log """
    server: grunt -p #{PORT} -m #{MODE} -i #{INDEX}

    """
  http.createServer (req, res) ->
    route = path.resolve ROOT, (url.parse req.url).pathname.replace /^\//, ''
    return serve route, req, res
  .listen PORT

module.exports = (grunt) ->
  grunt.initConfig

    pkg: grunt.file.readJSON 'package.json'

    coffee:
      compile:
        files: [{
          expand: yes
          cwd: 'assets/'
          src: [ '**/*.coffee' ]
          dest: 'dist/'
          ext: '.js'
        }]

    stylus:
      compile:
        files: [{
          expand: yes
          cwd: 'assets/'
          src: [ '**/*.styl' ]
          dest: 'dist/'
          ext: '.css'
        }]

    jade:
      options:
        pretty: yes
      compile:
        files: [{
          expand: yes
          cwd: 'assets/'
          src: [ '**/*.jade' ]
          dest: 'dist/'
          ext: '.html'
        }]

    uglify:
      minify:
        files: [{
          expand: yes
          cwd: 'dist/'
          src: [ '**/*.js' ]
          dest: 'public/'
          ext: '.js'
        }]

    cssmin:
      minify:
        files: [{
          expand: yes
          cwd: 'dist/'
          src: [ '**/*.css' ]
          dest: 'public/'
          ext: '.css'
        }]

    htmlmin:
      minify:
        files: [{
          expand: yes
          cwd: 'dist/'
          src: [ '**/*.html' ]
          dest: 'public/'
          ext: '.html'
        }]

    watch:
      options:
        debounceDelay: 1000
        dateFormat: (time) ->
          grunt.log.writeln "The watch finished in #{time}ms at #{new Date().toLocaleTimeString()}"
      coffee:
        files: ['assets/**/*.coffee']
        tasks: ['coffee', 'uglify']
      jade:
        files: ['assets/*.jade']
        tasks: ['jade']
      stylus:
        files: ['assets/**/*.styl']
        tasks: ['stylus', 'cssmin']

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-stylus'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-cssmin'
  grunt.loadNpmTasks 'grunt-contrib-htmlmin'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  grunt.registerTask 'build', ['coffee', 'uglify', 'stylus', 'cssmin', 'jade', 'htmlmin']
  grunt.registerTask 'default', ['build', 'watch']
