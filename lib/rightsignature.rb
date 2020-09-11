require 'httparty'
require 'xml-fu'
require 'oauth'
require 'rightsignature2013errors'
require 'rightsignature2013helpers/normalizing'
require 'rightsignature2013document'
require 'rightsignature2013template'
require 'rightsignature2013account'
require 'rightsignature2013connection/oauth_connection'
require 'rightsignature2013connection/token_connection'
require 'rightsignature2013connection'

XmlFu.config.symbol_conversion_algorithm = :none
