#!/usr/bin/env ruby

#
# If you have multiple commits to merge with a single PR,
# smash all the commit messages together into a single string
# to create a commit message that looks relatively nice in a
# Github PR, assuming the commit message is formatted nicely.
# Prints the result.
#
# Maybe the summary lines should include markdown insertion.
# Maybe this could put a PR to github for me.
#
# Example:
# * commit d0844
# | Author: Gandalf <gandalf@example.com>
# | Date:   Mon May 7 21:26:58 2018 -0600
# |
# |     Commit Summary
# |
# |     - Commit description why.
# |     - Commit description what.
# |
# * commit 71d30
# | Author: Gandalf <gandalf@example.com>
# | Date:   Mon May 7 21:15:52 2018 -0600
# |
# |     Another Commit
# |
# |     - Commit summary again.
#
#
# Becomes:
#
# Commit Summary
#
# - Commit description why.
# - Commit description what.
#
# Another Commit
#
# - Commit summary again.
#

require "Open3"

def usage
  puts "Usage: ruby cs.rb <git-repo> <parents>"
end

def main
  if ARGV.length < 2
    usage
    exit 1
  end

  git_repo = ARGV[0]
  base = ARGV[1]

  big_commit_message = []

  sep = "#!;"
  sep_end = "#!END;"

  stdout, status = Open3.capture2("git", "-C", git_repo, "log", "--pretty=format:%s#{sep}%b#{sep_end}", "HEAD...HEAD~#{base}")
  raise "Error running git log" unless status.success?

  stdout.split(sep_end).reverse.each do |commit|
    summary_line, body = commit.split(sep)
    message = summary_line + "\n"
    message += "\n#{body}\n" if !body.nil?
    big_commit_message << message
  end

  puts big_commit_message
end

main
