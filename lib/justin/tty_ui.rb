# encoding: utf-8

# Almost the simplest possible thing that can possibly work.  Set
# $DEBUG if you want to see any output under normal conditions.
module Justin
  class TtyUI
    def info(msg, newline = nil)
    end

    def confirm(msg, newline = nil)
    end

    def warn(msg, newline = nil)
      STDERR.puts msg
    end

    def error(msg, newline = nil)
      STDERR.puts msg
    end

    def debug(msg, newline = nil)
      STDERR.puts msg if $DEBUG
    end

    def debug?
      true
    end

    def quiet?
      false
    end

    def ask(msg)
      # If this ever happens, we've failed.
      raise "Had to ask \"#{msg}\"\nI don't know how to do this."
    end

    def level=(level)
    end

    def level(name = nil)
    end

    def trace(e, newline = nil)
      msg = ["#{e.class}: #{e.message}", *e.backtrace].join("\n")
      STDERR.puts "#{msg}#{newline}" if $DEBUG
    end

    def silence
      yield
    end

  end
end
