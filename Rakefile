task :default => :compile

desc 'Compile the sources with macrubyc'
task :compile do
  if (`which macruby`.empty?)
    puts 'You need MacRuby (http://macruby.org) to use Snappy!'
  else
    Dir.chdir('src')
    `macrubyc main.rb snappy.rb -o snappy`
  end
end

desc 'Install Snappy (use rake install PREFIX=/opt/local to change prefix path, default /usr)'
task :install do
  exec = 'src/snappy'
  if File.exist?(exec)
    require 'fileutils'
    prefix = ENV['PREFIX'] || '/usr'
    FileUtils.cp(exec, File.join(prefix, 'bin'))
    puts "Executable installed in #{File.join(prefix, 'bin', 'snappy')}"
  else
    puts "Run 'rake compile' first!"
  end
end

desc 'Uninstall Snappy'
task :uninstall do
  ENV['PATH'].split(':').each do |bin_dir|
    snappy = File.join(bin_dir, 'snappy')
    if File.exist?(snappy)
      File.delete(snappy)
      puts "Executable #{snappy} deleted"
    end
  end
end

desc 'Create a zip file of Snappy'
task :release do
  system 'zip snappy.zip src/snappy'
end

desc 'Clean'
task :clean do
  `rm src/*.o src/snappy`
end
