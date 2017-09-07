# -*- encoding : utf-8 -*-

module BingAdsApi

	# Public : Base class for service object
	#
	# Author:: jlopezn@neonline.cl
	#
	class Service

		attr_accessor :client_proxy, :environment, :max_retry_attempts

		# Default logger for services
		LOGGER = Logger.new(STDOUT)


		# Public : Constructor
		#
		# Author:: jlopezn@neonline.cl
		#
		# === Parameters
		# * +options+ - Hash with autentication and environment settings
		#
		# === Options
		# * environment - +:production+ or +:sandbox+
		# * username - Bing Ads username
		# * passwrod - Bing Ads user's sign-in password
		# * developer_token - client application's developer access token
		# * customer_id - identifier for the customer that owns the account
		# * account_id - identifier of the account that own the entities in the request
		# * proxy - Hash with any Client Proxy additional options (such as header, logger or enconding)
		#
		# === Examples
		#   service = BingAdsApi::Service.new(
		#     :environment => :sandbox,
		#     :username    => 'username',
		#     :password    => 'pass',
		#     :developer_token => 'SOME_TOKEN',
		#     :account_id  => 123456,
		#     :customer_id => 654321,
		#     :proxy => {:logger => Rails.logger}
		#   )
		#   # => <Service>
		def initialize(options={})

			# Service Environment
			self.environment = options[:environment]

			# ClientProxy settings
			clientProxySettings = {
				:authentication_token => options[:authentication_token],
				:username => options[:username],
				:password => options[:password],
				:developer_token => options[:developer_token],
				:account_id => options[:account_id],
				:customer_id => options[:customer_id],
				:wsdl_url => options[:wsdl] || solve_wsdl_url
			}

			# Additionsl ClientProxy settings
			clientProxySettings[:proxy] = options[:proxy] if options[:proxy]

			# ClientProxy creation
			self.client_proxy = BingAdsApi::ClientProxy.new(clientProxySettings)

			self.max_retry_attempts = options[:max_retry_attempts] || 0
		end


		# Public : This is a utility wrapper for calling services into the
		# +ClientProxy+. This methods handle all the +Savon::Client+ Exceptions
		# and returns a Hash with the call response
		#
		# Author:: jlopezn@neonline.cl
		#
		# === Parameters
		# +operation+ - name of the operation to be called
		# +message+ - hash with the parameters to the operation
		#
		# === Examples
		#   service.call(:some_operation, {key: value})
		#   # => <Hash>
		#
		# Returns:: Hash with the result of the service call
		# Raises:: ServiceError if the SOAP call, the ClientProxy fails or the response is invalid
		def call(operation, message, &block)
			retries_made = 0
			raise "You must provide an operation" if operation.nil?
			begin
				LOGGER.debug "BingAdsApi Service"
				LOGGER.debug "   Calling #{operation.to_s}"
				LOGGER.debug "   Message: #{message}"
				response = self.client_proxy.call(operation.to_sym,
					message: message)
				LOGGER.debug "response header:"
				LOGGER.debug "\t#{response.header}"

				LOGGER.info "Operation #{operation.to_s} call success"
				return response.hash
			rescue Savon::SOAPFault => error
				LOGGER.error "SOAP Error calling #{operation.to_s}: #{error.http.code}"
				fault_detail = error.to_hash[:fault][:detail]
				if fault_detail.key?(:api_fault_detail)
					api_fault_detail = BingAdsApi::ApiFaultDetail.new(fault_detail[:api_fault_detail])
					raise BingAdsApi::ApiException.new(
						api_fault_detail, "SOAP Error calling #{operation.to_s}")
				elsif fault_detail.key?(:ad_api_fault_detail)
					ad_api_fault_detail = BingAdsApi::AdApiFaultDetail.new(fault_detail[:ad_api_fault_detail])
					raise BingAdsApi::ApiException.new(
						ad_api_fault_detail, "SOAP Error calling #{operation.to_s}")
				else
					raise
				end
			rescue Savon::HTTPError => error
				LOGGER.error "Http Error calling #{operation.to_s}: #{error.http.code}"
				raise
			rescue Savon::InvalidResponseError => error
				LOGGER.error "Invalid server reponse calling #{operation.to_s}"
				raise
			rescue
				# for any other exceptions, retry with an exponential backoff
				if retries_made < max_retry_attempts
					sleep(2**(retries_made))
					retries_made += 1
					retry
				else
					raise
				end
			end
		end


		# Public : Extracts the actual response from the entire response hash.
		# For example, if you specify 'AddCampaigns', this method will return
		# the content of 'AddCampaignsResponse' tag as a Hash
		#
		# Author:: jlopezn@neonline.cl
		#
		# === Parameters
		# response - The complete response hash received from a Operation call
		# method - Name of the method of with the 'reponse' tag is require
		#
		# === Examples
		#   service.get_response_hash(Hash, 'add_campaigns')
		#   # => Hash
		#
		# Returns:: Hash with the inner structure of the method response hash
		# Raises:: exception
		def get_response_hash(response, method)
			return response[:envelope][:body]["#{method}_response".to_sym]
		end

		private

			# Private : This method must be overriden by specific services.
			# Returns:: the service name
			#
			# Author:: jlopezn@neonline.cl
			#
			# Examples
			#   get_service_name
			#   # => "service_name"
			#
			# Returns:: String with the service name
			# Raises:: exception if the specific Service class hasn't overriden this method
			def get_service_name
				raise "Should return the a service name from config.wsdl keys"
			end


			# Private : Solves the service WSDL URL based on his service name
			#    and environment values
			#
			# Author:: jlopezn@neonline.cl
			#
			# Examples
			#   solve_wsdl_url
			#   # => "https://bing.wsdl.url.com"
			#
			# Returns:: String with the Service url
			def solve_wsdl_url
				config = BingAdsApi::Config.instance
				return config.service_wsdl(environment, get_service_name)
			end

	end

end
