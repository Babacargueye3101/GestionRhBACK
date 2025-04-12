require 'net/http'
require 'uri'
require 'json'

class OrangeMoneyService
  BASE_URL = "https://api.orange-sonatel.com/api/eWallet/v1/payments/onestep"
  CLIENT_ID = ENV['CLIENT_ID']
  CLIENT_SECRET = ENV['CLIENT_SECRET']

  def initialize
    @token = authenticate
  end

  def authenticate
    auth_url = "https://api.orange-sonatel.com/oauth/token"
    
    begin
      uri = URI.parse(auth_url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.scheme == 'https'
  
      request = Net::HTTP::Post.new(uri.request_uri)
      request['Content-Type'] = 'application/x-www-form-urlencoded'
      request.body = URI.encode_www_form(
        grant_type: 'client_credentials',
        client_id: CLIENT_ID,
        client_secret: CLIENT_SECRET
      )

      response = send_request(uri, request)
      response['access_token']
    rescue => e
      Rails.logger.error "Orange Money Auth Error: #{e.message}"
      raise
    end
  end

  def initiate_payment(phone_number, amount, reference, otp)
    uri = URI(BASE_URL)
    request = Net::HTTP::Post.new(uri)
    request["Content-Type"] = "application/json"
    request["Authorization"] = "Bearer #{@token}"

    body = {
      customer: {
        idType: "MSISDN",
        id: phone_number,
        otp: otp
      },
      partner: {
        idType: "CODE",
        id: ENV['PARTNER_ID']
      },
      amount: {
        value: 50,
        unit: "XOF"
      },
      reference: reference
    }

    request.body = body.to_json
    send_request(uri, request)
  end

  private

  def send_request(uri, request)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    response = http.request(request)
    JSON.parse(response.body) rescue nil
  end
end
