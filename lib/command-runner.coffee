{BufferedProcess} = require 'atom'
Utils = require './utils'

class CommandRunner
  processor: BufferedProcess
  commandResult: ''

  constructor: (command, callback)->
    @command = command.replace('%', '$ATOM_FILE')
    @callback = callback

  collectResults: (output) =>
    @commandResult += output.toString()
    @returnCallback()

  exit: (code) =>
    @returnCallback()

  processParams: ->
    command: '/usr/local/bin/fish'
    args: ['-c', @command]
    options:
      cwd: atom.project.getPath()
      env:
        ATOM_FILE: atom.workspace.getActiveEditor().getPath()
    stdout: @collectResults
    stderr: @collectResults
    exit: @exit

  returnCallback: =>
    @callback(@command, @commandResult)

  runCommand: ->
    @commandResult = ''
    @process = new @processor @processParams()
    @returnCallback()

  kill: ->
    if @process?
      @process.kill()

module.exports =
  CommandRunner: CommandRunner
