require 'httparty'
require 'xml-fu'
require 'oauth'
require 'rightsignature2013/errors'
require 'rightsignature2013/helpers/normalizing'
require 'rightsignature2013/document'
require 'rightsignature2013/template'
require 'rightsignature2013/account'
require 'rightsignature2013/connection/oauth_connection'
require 'rightsignature2013/connection/token_connection'
require 'rightsignature2013/connection'

XmlFu.config.symbol_conversion_algorithm = :none
