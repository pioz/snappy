#!/usr/bin/env macruby
require 'optparse'
require 'snappy'
require 'version'

options = {}
parser = OptionParser.new do |opts|
  opts.banner = 'Usage: snappy [<options> <filename>]'
  opts.separator ''
  opts.separator 'Options:'
  opts.on('-t', '--title TITLE', 'Print a little title on snapshot') { |t| options[:t] = t }
  opts.on('-m', '--message MESSAGE', 'Print a message on snapshot') { |m| options[:m] = m }
  opts.on('-w', '--wait SECONDS', 'Wait seconds before take the snapshot') { |w| options[:w] = w }
  opts.on('-d', '--device DEVICE', 'Set the device to use') { |d| options[:d] = d }
  opts.on_tail('-l', '--list', 'List available devices') { puts Snappy.devices_list; exit }
  opts.on_tail('-v', '--version', 'Show version') { puts Snappy::VERSION; exit }
  opts.on_tail('-h', '--help', 'Show this help message') { puts opts; exit }
end
begin
  parser.parse!
rescue OptionParser::InvalidOption
  puts parser.help; exit
end
if ARGV.size > 1
  puts parser.help; exit
end
options[:filename] = ARGV[0]

Snappy.alloc.init(options).snap
