#!/usr/bin/env macruby
require 'snappy'
require 'optparse'

VERSION = '0.0.1'

options = {}
parser = OptionParser.new do |opts|
  opts.banner = 'Usage: snappy [<options> <filename>]'
  opts.separator ''
  opts.separator 'Options:'
  opts.on('d', '--device DEVICE', 'Set the device by name') { |d| options[:d] = d }
  opts.on('-w', '--wait SECONDS', 'Wait seconds before to take the snapshot') { |w| options[:w] = w }
  opts.on_tail('-l', '--list', 'Show available devices') { puts Snappy.devices_list; exit }
  opts.on_tail('-v', '--version', 'Print version') { puts VERSION; exit }
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