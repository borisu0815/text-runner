require! {
  'chalk' : {cyan}
  'fs'
  'jsdiff-console'
  'path'
  'prelude-ls' : {capitalize, filter}
}


module.exports  = ({formatter, searcher}, done) ->

  file-path = searcher.node-content type: 'text', ({nodes, content}) ->
    | nodes.length is 0    =>  'no file path found'
    | nodes.length > 1     =>  "multiple file paths found: #{nodes |> map (.content) |> map ((a) -> cyan a) |> (.join ' and ')}"
    | content.length is 0  =>  'no path given for file to verify'

  expected-content = searcher.node-content type: 'fence', ({nodes}) ->
    | nodes.length is 0  =>  'no text given to compare file content against'
    | nodes.length > 1   =>  'found multiple content blocks for file to verify, please provide only one'

  formatter.start-activity "verifying file #{cyan file-path}"
  try
    actual-content = fs.read-file-sync path.join(global.working-dir, file-path), 'utf8'
  catch
    if e.code is 'ENOENT'
      formatter.activity-error "file #{file-path} not found"
      return done 1
    else throw e
  jsdiff-console actual-content.trim!, expected-content.trim!, (err) ~>
    if err
      formatter.activity-error "mismatching content in #{cyan file-path}:\n#{err.message}"
    formatter.activity-success!
    done null, 1