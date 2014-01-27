
'use strict'

module.exports = (grunt) ->

  files = (src, dest) ->
    return [{ expand: yes, cwd: 'assets/', src: [src], dest: dest }]

  require 'coffee-script'
  require 'coffee-errors'

  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-stylus'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-imagemin'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-notify'

  grunt.registerTask 'build', ['copy', 'imagemin', 'coffee', 'stylus', 'jade', 'imagemin']
  grunt.registerTask 'default', ['build', 'connect', 'watch']

  fs = require 'fs'
  url = require 'url'
  path = require 'path'

  grunt.initConfig

    pkg: grunt.file.readJSON 'package.json'

    copy:
      release:
        files: [{
          expand: yes
          cwd: 'assets/'
          src: [ '**/*', '!**/*.{jpg,png,gif,coffee,styl,jade}' ]
          dest: 'public/'
        }]

    coffee:
      options:
        sourceMap: yes
        sourceRoot: './'
      release:
        files: [{
          expand: yes
          cwd: 'assets/'
          src: [ '**/*.coffee' ]
          dest: 'public/'
          ext: '.js'
        }]

    stylus:
      release:
        files: [{
          expand: yes
          cwd: 'assets/'
          src: [ '**/*.styl' ]
          dest: 'public/'
          ext: '.css'
        }]

    jade:
      release:
        files: [{
          expand: yes
          cwd: 'assets/'
          src: [ '**/*.jade' ]
          dest: 'public/'
          ext: '.html'
        }]

    imagemin:
      release:
        files: [{
          expand: yes
          cwd: 'assets/'
          src: [ '**/*.{jpg,png,gif}' ]
          dest: 'public/'
        }]

    watch:
      options:
        livereload: yes
        interrupt: yes
      imgbuild:
        files: [ 'assets/**/*.{jpg,png,gif}' ]
        tasks: [ 'imagemin' ]
      jsbuild:
        files: [ 'assets/**/*.coffee' ]
        tasks: [ 'coffee' ]
      cssbuild:
        files: [ 'assets/**/*.styl' ]
        tasks: [ 'stylus' ]
      jadebuild:
        files: [ 'assets/*.jade' ]
        tasks: [ 'jade' ]

    connect:
      server:
        options:
          hostname: '*'
          port: 3000
          middleware: (connect, options) ->
            mw = [connect.logger 'dev']
            mw.push (req, res) ->
              index = path.resolve 'public', 'index.html'
              route = path.resolve 'public', (url.parse req.url).pathname.replace /^\//, ''
              fs.exists route, (exist) ->
                fs.stat route, (err, stat) ->
                  return fs.createReadStream(route).pipe(res) if exist and stat.isFile()
                  return fs.createReadStream(index).pipe(res)
            return mw
