
'use strict'

module.exports = (grunt) ->

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
  dgram = require 'dgram'

  f = (src, dest) ->
    return [{ expand: yes, cwd: 'assets/', src: [src], dest: 'public/' }]

  grunt.initConfig

    pkg: grunt.file.readJSON 'package.json'

    copy:
      release:
        files: f [ '**/*', '!**/*.{jpg,png,gif,coffee,styl,jade}' ]

    coffee:
      options:
        sourceMap: yes
        sourceRoot: './'
      release:
        files: f [ '**/*.coffee' ]

    stylus:
      release:
        files: f [ '**/*.styl' ]

    jade:
      release:
        files: f [ '**/*.jade' ]

    imagemin:
      release:
        files: f [ '**/*.{jpg,png,gif}' ]

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
            mw.push (req, res, next) ->
              return next() unless req.url is '/push'
              SIO_RIGHT = 2
              SIO_LEFT = 1
              ID_NECK = 0
              ID_SHOULDER_ROTATION = 1
              ID_SHOULDER_UP_DOWN = 2
              ID_ELBOW = 4
              ID_HIP_OPEN_CLOSE = 6
              ID_HIP_BACK_FORTH = 7
              ID_KNEE = 8
              ID_ANKLE_UP_DOWN = 9
              ID_ANKLE_OPEN_CLOSE = 10
              POSITION_DEFAULT_MAX = 10000
              POSITION_DEFAULT = 7500
              POSITION_DEFAULT_MIN = 5000
              makeIcs = (sio, id) ->
                return (id * 2) + (sio - 1)
              json = [
                { frame: 50 }
                {
                  ics: makeIcs SIO_RIGHT, ID_NECK
                  value: 5000
                }
                { command: 3 }
              ]
              message = new Buffer JSON.stringify json
              client = dgram.createSocket 'udp4'
              client.send message, 0, message.length, 3500, '*.*.*.*', (err, bytes) ->
                console.error err if err
                console.log "send #{bytes} bytes"
                console.log json
                client.close()
                res.end 'done'
            mw.push (req, res) ->
              index = path.resolve 'public', 'index.html'
              route = path.resolve 'public', (url.parse req.url).pathname.replace /^\//, ''
              fs.exists route, (exist) ->
                fs.stat route, (err, stat) ->
                  return fs.createReadStream(route).pipe(res) if exist and stat.isFile()
                  return fs.createReadStream(index).pipe(res)
            return mw
