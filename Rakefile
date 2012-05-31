require './src/version.rb'
BIN = 'snappy'

task :default => :compile

desc 'Compile the sources with macrubyc'
task :compile do
  if (`which macruby`.empty?)
    puts 'You need MacRuby (http://macruby.org) to use Snappy!'
  else
    SOURCES = %w(main.rb snappy.rb image_texter.rb version.rb)
    Dir.chdir('src') do
      system "macrubyc #{SOURCES.join(' ')} -o #{BIN}"
    end
  end
end

desc 'Install Snappy (use rake install PREFIX=/opt/local to change prefix path, default /usr)'
task :install do
  exec = File.join('src', BIN)
  if File.exist?(exec)
    require 'fileutils'
    prefix = ENV['PREFIX'] || '/usr'
    FileUtils.cp(exec, File.join(prefix, 'bin'))
    puts "Executable installed in #{File.join(prefix, 'bin', BIN)}"
  else
    puts "Run 'rake compile' first!"
  end
end

desc 'Uninstall Snappy'
task :uninstall do
  ENV['PATH'].split(':').each do |bin_dir|
    snappy = File.join(bin_dir, BIN)
    if File.exist?(snappy)
      File.delete(snappy)
      puts "Executable #{snappy} deleted"
    end
  end
end

desc 'Create a zip file of Snappy'
task :release => :compile do
  system "zip #{BIN}-#{Snappy::VERSION}.zip src/#{BIN}"
end

desc 'Clean'
task :clean do
  Dir.chdir('src') do
    system "rm *.o #{BIN}"
  end
end
