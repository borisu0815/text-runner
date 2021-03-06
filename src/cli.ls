require! {
  'chalk' : {red}
  'cli-cursor'
  'end-child-processes'
  'minimist'
  '../package.json' : pkg
  'prelude-ls' : {filter, split, tail}
  './text-runner' : TextRunner
  'update-notifier'
}
debug = require('debug')('text-runner:cli')

update-notifier({pkg}).notify!
cli-cursor.hide!

argv = minimist process.argv.slice(2)
commands-text = delete argv._
commands = (commands-text[0] or '') |> split ' '
                                    |> filter -> it isnt 'text-run'
text-runner = new TextRunner argv
text-runner.execute (commands[0] or 'run'), tail(commands), (err) ->
  | err and err.message isnt 1  =>  console.log red err

  end-child-processes!
  process.exit if err then 1 else 0
