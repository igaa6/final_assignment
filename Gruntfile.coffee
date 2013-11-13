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

    concat:
      dist:
        src: [ 'src' ]

    watch:
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
