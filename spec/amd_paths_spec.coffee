describe "AmdPaths", ->

  AmdPaths  = require("../lib/amd_paths")
  path      = require("path")
  expect    = require("chai").expect
  _         = require("lodash")

  context "create a instance", ->

    before ->
      @amdPaths = new AmdPaths(
        cwd: __dirname
      )

    describe "#paths()", ->

      context "call(module_1)", ->

        before (done)->
          @amdPaths.paths(
            [
              "fixtures/module_1.js"
            ]
            (result)=>
              @result = result
              done()
          )

        context "names", ->

          before ->
            @names = _.keys(@result)

          it "returns a module path", ->
            expect(@names.length).to.eq 1

          it "includes module_1", ->
            expect(@names).to.include "module_1"

      context "call(multi_modules)", ->

        before (done)->
          @amdPaths.paths(
            [
              "fixtures/multi_modules.js"
            ]
            (result)=>
              @result = result
              done()
          )

        context "names", ->

          before ->
            @names = _.keys(@result)

          it "returns 3 module paths", ->
            expect(@names.length).to.eq 3

          it "includes multi_modules/module_1", ->
            expect(@names).to.include "multi/module_1"

          it "includes multi_modules/module_2", ->
            expect(@names).to.include "multi/module_2"

          it "includes multi_modules/module_3", ->
            expect(@names).to.include "multi/module_3"

