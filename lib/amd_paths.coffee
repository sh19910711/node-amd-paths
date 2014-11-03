class AmdPaths
  acorn = require "acorn"
  walk  = require "acorn/util/walk"
  _     = require "lodash"
  fs    = require "fs"
  async = require "async"
  path  = require "path"

  constructor: (options)->
    @options = options
    _(@options).defaults 
      cwd: process.cwd()

  paths: (filePaths, callback)->
    configPaths = {}
    realFilePaths = _.map filePaths, @_realPath

    # read all files
    async.mapSeries realFilePaths, fs.readFile, (err, contents)=>
      throw err if err

      # parse each contents
      _.forEach contents, (content, ind)=>
        _.assign configPaths, @findPaths(content, realFilePaths[ind])

      # return paths object
      callback configPaths

  findPaths: (content, filePath)->
    configPaths = {}

    ast = acorn.parse(content)

    walkAncestorOpts = {
      CallExpression: (node)->
        if _isDefineFunc(node)
          if node.arguments[0].type == "Literal"
            moduleName = node.arguments[0].value
            configPaths[moduleName] = _toModuleName(filePath)
    }
    walk.ancestor ast, walkAncestorOpts

    configPaths

  _toModuleName = (modulePath)->
    modulePath.slice 0, -1 * path.extname(modulePath).length

  _isDefineFunc = (node)->
    node.callee.name == "define"

  _realPath: (filePath)=>
    path.join(@options.cwd, filePath)

module.exports = AmdPaths
