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
    async.mapSeries realFilePaths, fs.readFile, (err, contents)->
      throw err if err

      # parse each contents
      _.each contents, (content, ind)->
        ast = acorn.parse(content)
        walkAncestorOpts = {
          CallExpression: (node)->
            if _isDefineFunc(node)
              if node.arguments[0].type == "Literal"
                moduleName = node.arguments[0].value
                configPaths[moduleName] = _toModuleName(realFilePaths[ind])
        }
        walk.ancestor ast, walkAncestorOpts

      # return paths object
      callback configPaths

  _toModuleName = (modulePath)->
    modulePath.slice 0, -1 * path.extname(modulePath).length

  _isDefineFunc = (node)->
    node.callee.name == "define"

  _realPath: (filePath)=>
    path.join(@options.cwd, filePath)

module.exports = AmdPaths
