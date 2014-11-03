gulp  = require "gulp"
bump  = require "gulp-bump"
git   = require "gulp-git"

gulp.task "bump!", ->
  gulp.src(["package.json"])
    .pipe bump(type: "patch")
    .pipe gulp.dest("./")

gulp.task(
  "release"
  [
    "bump!"
  ]
  ->
    pkg = require("../package.json")
    gulp.src(["lib/**/*", "package.json"])
      .pipe git.commit("npm: bump version into #{pkg["version"]}")
      .on "end", ->
        git.tag(pkg["version"], pkg["version"], ->)
)

