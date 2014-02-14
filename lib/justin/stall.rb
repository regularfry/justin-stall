# encoding: utf-8

require 'justin/bundler_loader'
require 'optparse'


module Justin

  module Stall


    VERSION="0.0.1"


    module Options
      def self.parse( argv )
        options = {}
        parser = OptionParser.new do |prsr|
          prsr.banner= <<-BANNER
justin-stall, version #{Justin::Stall::VERSION}

Usage:  #{$0} [options] < Gemfile.lock

          BANNER

          prsr.on( "--without GROUPS",
                   "A comma-separated list of groups to skip installing." ) do |groups|
            options[:without] = groups.split(",").map{|s| s.to_sym}
          end

          prsr.on( "-h", "--help",
                   "This message." ) do
            puts prsr
            puts
            exit 0
          end


        end
        parser.parse argv
        options[:without] ||= []
        options
      end
    end


    class NoLockDefinition
      def initialize( definition )
        @_definition = definition
      end

      def lock
        #nop
      end

      def method_missing( sym, *args, &blk )
        @_definition.__send__ sym, *args, &blk
      end
    end # class NoLockDefinition


    def self.run( argv )
      options = Options.parse argv
      setup_options options


      input = STDIN.read
      lock_contents, gemfile_contents = input.split /GEMFILE/

      # we need this for install_gem_from_spec, and we can't get it
      # from Definition
      Bundler.locked_gems=Bundler::LockfileParser.new lock_contents

      definition = build_definition gemfile_contents, lock_contents
      install definition
    end


    private

    def self.setup_options( options )
      if options[:without]
        Bundler.settings.without = options[:without]
      end
    end

    def self.build_definition( gemfile_contents, lock_contents )
      dsl = Bundler::Dsl.new
      dsl.eval_gemfile "Gemfile", gemfile_contents
      definition = IO.pipe {|io_r, io_w|
        io_w.write lock_contents
        io_w.close
        NoLockDefinition.new( dsl.to_definition( io_r, {} ) )
      }
      definition.resolve_remotely!
      definition
    end


    def self.install( definition )
      Bundler::Installer.post_install_messages = {}
      installer = Bundler::Installer.new Bundler.root, definition
      installer.__send__ :install_sequentially, false
    end


  end # module Stall


end # module Justin
