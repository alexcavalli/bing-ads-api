# -*- encoding : utf-8 -*-

module BingAdsApi

	# Public : ClientProxy es un objeto para encapsular la conexión y request
	#   de servicios a la API de Bing. En su inicialización requiere los datos
	#   de autenticación y el WSDL al servicio que se requiere.
	#
	# Author:: jlopezn@neonline.cl
	#
	# Examples
	#   # => hash con datos autenticación y WSDL
	#   options = {
	#     :username => "username",
	#     :password => "password",
	#     :developer_token => "THE_TOKEN",
	#     :customer_id => "123456",
	#     :account_id => "123456",
	#     :wsdl_url => "https://api.sandbox.bingads.microsoft.com/Api/Advertiser/CampaignManagement/v9/CampaignManagementService.svc?singleWsdl"
	#   }
	#   # => Instancia de ClientProxy
	#   client = BingAdsApi::ClientProxy.new(options)
	#   # => Llamada a servicio 'GetCampaignsByAccountId'
	#   response = client.service.call(:get_campaigns_by_account_id,
	#     message: { Account_id: client.account_id})
	class ClientProxy

		# Public : Namespace para atributos bing. Hace referencia a la versión de API usada
		NAMESPACE = :v9

		# Public : Case empleado los nombres de atributos en los XML
		KEYS_CASE = :camelcase


		# Atributos del client proxy
		attr_accessor :username, :password, :developer_token, :authentication_token, :wsdl_url, :account_id, :customer_id, :service, :namespace

		# Public : Constructor
		#
		# Author:: jlopezn@neonline.cl
		#
		# === Parameters
		# options - Hash con valores de autenticación y WSDL
		#
		#
		# === Options
		# * username - Bing Ads username
		# * passwrod - Bing Ads user's sign-in password
		# * developer_token - client application's developer access token
		# * customer_id - identifier for the customer that owns the account
		# * account_id - identifier of the account that own the entities in the request
		# * wsdl_url - URL for the WSDL to be called
		# * proxy - Hash with any Savon Client additional options (such as header, logger or enconding)
		#
		# === Examples
		#   options = {
		#     :username => "username",
		#     :password => "password",
		#     :developer_token => "THE_TOKEN",
		#     :customer_id => "123456",
		#     :account_id => "123456",
		#     :wsdl_url => "https://api.sandbox.bingads.microsoft.com/Api/Advertiser/CampaignManagement/v9/CampaignManagementService.svc?singleWsdl"
		#   }
		#   # => Instancia de ClientProxy
		#   client = BingAdsApi::ClientProxy.new(options)
		#
		# Returns:: ClientProxy instance
		def initialize(options=nil)
			if options
				if options[:authentication_token]
					@authentication_token ||= options[:authentication_token]
				else
					@username    ||= options[:username]
					@password    ||= options[:password]
				end
				@developer_token ||= options[:developer_token]
				@wsdl_url        ||= options[:wsdl_url]
				@account_id      ||= options[:account_id]
				@customer_id     ||= options[:customer_id]
				@namespace       ||= options[:namespace]
			end
			self.service = get_proxy(options[:proxy])
		end


		# Public : Delegate for Savon::Client.call method
		#
		# Author:: jlopezn@neonline.cl
		#
		# === Parameters
		# service_name - Service to be called
		# message - Message for the service
		# options - Additional options for the service
		#
		# === Examples
		#   client.call_service(:some_service_name, {key: value})
		#   # => <Response>
		#
		# Returns:: Response from the Savon::Client
		# Raises:: Savon::SOAPFault Savon::HTTPError Savon::InvalidResponseError
		def call(service_name, message, options={})
		  self.service.call(service_name, message)
		end


		private
			# Internal : Wrapper for Savon client instances
			#
			# Author:: jlopezn@neonline.cl
			#
			# Examples
			#   get_proxy
			#   # => <Savon::Client>
			#
			# Returns:: Savon client instance
			def get_proxy(client_settings)
				settings = {
					convert_request_keys_to: KEYS_CASE,
					wsdl: self.wsdl_url,
					namespace_identifier: NAMESPACE,
					soap_header: build_headers
				}
				settings.merge!(client_settings) if client_settings

				return Savon.client(settings)
			end


			def build_headers
				headers = {
					"#{NAMESPACE.to_s}:CustomerAccountId" => self.account_id,
					"#{NAMESPACE.to_s}:CustomerId" => self.customer_id,
					"#{NAMESPACE.to_s}:DeveloperToken" => self.developer_token,
				}
				if self.authentication_token
					headers["#{NAMESPACE.to_s}:AuthenticationToken"] = self.authentication_token
				else
					headers["#{NAMESPACE.to_s}:UserName"] = self.username
					headers["#{NAMESPACE.to_s}:Password"] = self.password
				end
				return headers
			end
	end

end
