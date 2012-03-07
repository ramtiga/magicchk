# encoding: utf-8
require 'fileutils'
require 'tempfile'

module MagicCheck
  extend self

  def run(argv)
    argv.each do |f|
      unless chk_magic_comment?(f)
        insert_magic_comment(f)
        puts "#{f} => insert complete."
      else
        puts "#{f} => already written."
      end
    end
  end

  def chk_magic_comment?(file)
    begin
      File.open(file) do |f|
        return true if f.readline =~ /^#.*coding.*:.*$/
      end
      false
    rescue 
      "file open error"
    end
  end

  def insert_magic_comment(file)
    temp = Tempfile.new("my-file")
    temp.open
    temp.puts "# coding: utf-8"
    
    File.open(file) do |f|
      f.each do |line|
        temp.puts line    
      end
    end
    temp.flush
    FileUtils.cp(temp, file)
  ensure
    temp.close
  end
end

