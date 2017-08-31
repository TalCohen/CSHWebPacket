# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Packet::Application.initialize!

# Haddock Dictionary for Password Generation
Haddock::Password.diction = "words.txt"
