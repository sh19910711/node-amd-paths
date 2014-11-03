gulp  = require "gulp"
mocha = require "gulp-mocha"

gulp.task "test", ->
  gulp.src ["spec/**/*_spec.coffee"]
    .pipe mocha()

