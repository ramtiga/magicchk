# encoding: utf-8
require 'fileutils'
require 'tempfile'

module Magicchk
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
        2.times do
          return true if f.readline =~ /^#.*coding.*:.*$/
        end
      end
    rescue 
      "file open error"
    end
    false
  end

  def insert_magic_comment(file)
      
    temp = Tempfile.new("my-file")
    temp.open
    
    ret = chk_shebang?(file)
    if ret
      temp.puts ret
    end
    temp.puts "# coding: utf-8"
    
    File.open(file) do |f|
      f.each do |line|
        if ret
          ret = false
          next
        end
        temp.puts line    
      end
    end
    temp.flush
    FileUtils.cp(temp, file)
  ensure
    temp.close
  end
  
  def chk_shebang?(file)
    File.open(file) do |f|
      chk = f.readline
      return chk if chk =~ /^#!/
    end
    false
  end
end

