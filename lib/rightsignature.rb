require 'httparty'
require 'xml-fu'
require 'oauth'
require 'RightSignature2013/errors'
require 'RightSignature2013/helpers/normalizing'
require 'RightSignature2013/document'
require 'RightSignature2013/template'
require 'RightSignature2013/account'
require 'RightSignature2013/connection/oauth_connection'
require 'RightSignature2013/connection/token_connection'
require 'RightSignature2013/connection'

XmlFu.config.symbol_conversion_algorithm = :none
