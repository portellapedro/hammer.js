module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    # meta options
    meta:
      banner: '/*! <%= pkg.title || pkg.name %> - v<%= pkg.version %> - ' +
      '<%= grunt.template.today("yyyy-mm-dd") %>\n ' + '<%= pkg.homepage ? "* " + pkg.homepage + "\\n *\\n " : "" %>' +
      '* Copyright (c) <%= grunt.template.today("yyyy") %> <%= pkg.author.name %> <<%= pkg.author.email %>>;\n' +
      ' * Licensed under the <%= _.pluck(pkg.licenses, "type").join(", ") %> license */\n\n'

    # concat src files
    concat:
      options:
        separator: '\n\n'
      dev:
        options:
          banner: '<%= meta.banner %>'
        src: [
          'src/intro.js'
          'src/core.js'
          'src/setup.js'
          'src/instance.js'
          'src/event.js'
          'src/pointerevent.js'
          'src/utils.js'
          'src/detection.js'
          'src/gestures.js'
          'src/outro.js']
        dest: 'dist/hammer.js'
      devjquery:
        src: [
          'dist/hammer.js'
          'plugins/jquery.hammer.js']
        dest: 'dist/jquery.hammer.js'

    # minify the sourcecode
    uglify:
      release:
        options:
          banner: '<%= meta.banner %>'
        files:
          'dist/hammer.min.js': ['dist/hammer.js']
          'dist/jquery.hammer.min.js': ['dist/jquery.hammer.js']

    # check for optimisations and errors
    jshint:
      options:
        curly: true
        expr: true
        newcap: true
        quotmark: 'single'
        regexdash: true
        trailing: true
        undef: true
        unused: true
        maxerr: 100
        eqnull: true
        sub: false
        browser: true
      build:
        src: ['dist/<%= pkg.name %>-<%= pkg.version %>.js']

    # watch for changes
    watch:
      scripts:
        files: 'src/*.js'
        tasks: ['concat']
        options:
          interrupt: true

    # simple node server
    connect:
      server:
        options:
          hostname: "0.0.0.0"

    # tests
    qunit:
      all: ['tests/**/*.html']

    # release
    bumpup: 'package.json'
    tagrelease:
      file: 'package.json'
      commit: true
      message: 'Release %version%'
      prefix: 'v'
      annotate: false


  # Load tasks
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-jshint'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-contrib-qunit'
  grunt.loadNpmTasks 'grunt-contrib-qunit'
  grunt.loadNpmTasks 'grunt-bumpup'
  grunt.loadNpmTasks 'grunt-tagrelease'


  # Default task(s).
  grunt.registerTask 'default', ['connect','watch']
  grunt.registerTask 'test', ['jshint','qunit']
  grunt.registerTask 'build', ['concat','uglify','test']

  grunt.registerTask 'release', (type)->
    type = (if type then type else "patch")
    grunt.task.run 'concat'
    grunt.task.run 'uglify'
    grunt.task.run 'test'
    grunt.task.run 'bumpup:'+type
    grunt.task.run 'tagrelease'