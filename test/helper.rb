$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')
$LOAD_PATH << File.join(File.dirname(__FILE__), '..')
$LOAD_PATH << File.join(File.dirname(__FILE__))

require 'rubygems'

require 'gemsurance'
require 'test/unit'
require "mocha/setup"
