begin
  require_relative '.env.rb'
rescue LoadError
end

require 'sequel/core'


#Sequel::Database.extension :identifier_mangling
Sequel::Database.extension :auto_literal_strings
Sequel::Database.extension :date_arithmetic
Sequel::Database.extension :pagination
Sequel::Database.extension :connection_validator
Sequel.split_symbols = true

# Delete APP_DATABASE_URL from the environment, so it isn't accidently
# passed to subprocesses.  APP_DATABASE_URL may contain passwords.
DB = Sequel.connect(ENV.delete('APP_DATABASE_URL') || ENV.delete('DATABASE_URL'))


