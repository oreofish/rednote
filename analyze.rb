#!/usr/local/bin/ruby

require 'rubygems'
require 'grit'

class GitCount
  def initialize
    @diffcount = Hash.new
    @timecount = Hash.new
  end

  def diff_count(filetype, diff)
    @diffcount[filetype] = 0 if @diffcount.has_key?(filetype) == false
    @diffcount[filetype] += diff.split("\n").count
    @timecount[filetype] = 0 if @timecount.has_key?(filetype) == false
    @timecount[filetype] += 1
  end

  def commit_func(commit)
    commit.diffs.each do |filediff|
      filetype = :html
      if filediff.b_path =~ /.*\.html$/ or filediff.b_path =~ /.*\.html\..*$/
        filetype = :html
      elsif filediff.b_path =~ /.*\.js$/ or filediff.b_path =~ /.*\.js\..*$/
        filetype = :js
      elsif filediff.b_path =~ /.*\.css/ or filediff.b_path =~ /.*\.css\..*$/
        filetype = :css
      elsif filediff.b_path =~ /^app\/models.*/
        filetype = :model
      elsif filediff.b_path =~ /^app\/controllers.*/
        filetype = :controller
      elsif filediff.b_path =~ /^spec\/.*/
        filetype = :test
      elsif filediff.b_path =~ /^config\/.*/
        filetype = :config
      elsif filediff.b_path =~ /^db\/.*/
        filetype = :db
      else
        filetype = :other
      end
      
      diff_count filetype, filediff.diff if filediff.new_file == false
      # p "OTHER: " + filediff.b_path if filetype == :other
    end
  end
  
  def output
    p @diffcount
    p @timecount
  end

end

repo = Grit::Repo.new(ARGV[0])
commit_step = 10
commit_max = 1000

gitcount = GitCount.new

0.step(commit_max, commit_step) do |count|
  commits = repo.commits('devel', commit_step, count)
  commits.each do |commit|
    gitcount.commit_func commit
  end
  break if commits.count == 0
end

gitcount.output
