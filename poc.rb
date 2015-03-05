#!/usr/bin/env ruby
#encoding: ascii-8bit

require 'socket'
require 'fileutils'
require 'pty'

read = ->h,re,*noout {
  s = ''
  re = Regexp.new Regexp.quote(re) unless re.is_a? Regexp
  loop do
    s << h.getc
    break if s =~ re
  end
  print s if noout.empty?
  $1 ? $1 : s
}

FileUtils.cp 'bytecode', '/tmp/bytecode'
File.open '/tmp/bytecode', 'r+b' do |h|
  h.seek 3542
  h.write "25\n\1"
end

master, slave = PTY.open
pr, po = IO.pipe
spawn ['CamlFeatherweight/camlfwrun', ''], '/tmp/bytecode', in: pr, out: slave
pr.close
slave.close

n = 25 # size of maze
read.(master, "Challenge:\r\n", true)
g = read.(master, /.*\$\r\n/, true).lines
v = {}
act = ''
puts g

dfs = ->r, c {
  return false if v[r*n+c]
  v[r*n+c] = true
  return true if r == n && c == n-1
  4.times {|d|
    rr = r+[-1,0,1,0][d]
    cc = c+[0,1,0,-1][d]
    next unless 0 <= rr && rr < n && 0 <= cc && cc < n || rr == n && cc == n-1 && ! v[rr*n+cc]
    if rr == r ? r == -1 || g[r+1][[c,cc].max*2] != '|' : g[[r,rr].max][c*2+1] != '_'
      if dfs.(rr, cc)
        act << 'urdl'[d]
        return true
      end
    end
  }
  false
}

dfs[-1,0]
po.puts act.reverse
begin
  while l = master.gets
    print l
  end
rescue Errno::EIO
end
