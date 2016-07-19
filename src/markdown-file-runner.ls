require! {
  'async'
  'fs'
  'prelude-ls' : {capitalize}
  'remarkable' : Remarkable
  './runners/console-with-dollar-prompt-runner' : ConsoleWithDollarPromptRunner
  './runners/console-with-input-from-table-runner' : ConsoleWithInputFromTableRunner
  './runners/create-file-with-content-runner' : CreateFileWithContentRunner
  './runners/verify-file-content-runner' : VerifyFileContentRunner
}
debug = require('debug')('markdown-file-runner')


# Runs the given Markdown file
class MarkdownFileRunner

  (@path) ->
    @markdown-parser = new Remarkable 'full', html: yes

    # the current MFR runner instance
    @current-runner = null

    # all runners
    @runners = []


  run: (done) ->
    debug "checking file #{@path}"
    markdown-text = fs.read-file-sync @path, 'utf8'

    markdown-ast = @markdown-parser.parse markdown-text, {}
    @_check-nodes markdown-ast
    async.each-series @runners,
                      ((runner, cb) -> runner.run cb),
                      done


  _check-nodes: (tree) ->
    for node in tree
      if node.type is 'htmltag'

        if matches = node.content.match /<a class="runMarkdown_([^"]+)">/
          throw new Error 'Found a nested <a class="runMarkdown_*"> block' if @running
          class-name = "#{capitalize matches[1]}Runner"
          debug "instantiating '#{class-name}'"
          clazz = eval class-name
          @current-runner = new clazz @world

        if node.content is '</a>'
          @runners.push @current-runner if @current-runner
          @current-runner = null

      @current-runner?.load node
      @_check-nodes node.children if node.children


module.exports = MarkdownFileRunner