require_relative 'db'
require 'sequel/model'



Sequel::Model.plugin :auto_validations
Sequel::Model.plugin :prepared_statements
Sequel::Model.plugin :subclasses


require_relative 'models/titlebot_url.rb'

require 'logger'
#LOGGER = Logger.new($stdout)
#LOGGER.level = Logger::INFO #FATAL
#DB.loggers << LOGGER


Sequel::Model.freeze_descendents
DB.freeze
