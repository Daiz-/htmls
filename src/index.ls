require! {
  lsc: \LiveScript
  base: './base'
  elems: './elements'
  voids: './void'
}
{filter, each, map, lines, unlines, unique} = require 'prelude-ls'

el = (name, close = 1) ->
  if (voids.index-of name) > -1 then close = 0
  "#name = (a, b) !-> out \\#name #close a, b\n"

indent = (str) ->
  str
  |> lines
  |> map (-> "  #it")
  |> unlines

module.exports = (code, output = "#base\n") ->
  [t.1 for t in (lsc.tokens code) when t.0 == \ID]
  |> filter (-> (elems.index-of it) > -1)
  |> unique
  |> each (-> output += el it)
  fn = "return (args)->\n" + indent "#output\n#code\n" + \str
  return (new Function lsc.compile fn, {+bare})!