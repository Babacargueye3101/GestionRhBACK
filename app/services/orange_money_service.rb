require 'net/http'
require 'uri'
require 'json'

class OrangeMoneyService
  BASE_URL = "https://api.sandbox.orange-sonatel.com/api/eWallet/v1/payments/onestep"
  CLIENT_ID = ENV['CLIENT_ID']
  CLIENT_SECRET = ENV['CLIENT_SECRET']

  def initialize
    @token = authenticate
  end

  def authenticate
    auth_url = "https://api.sandbox.orange-sonatel.com/oauth/token"
    uri = URI(auth_url)
    request = Net::HTTP::Post.new(uri)
    request["Content-Type"] = "application/x-www-form-urlencoded"
    request.body = "grant_type=client_credentials&client_id=#{CLIENT_ID}&client_secret=#{CLIENT_SECRET}"

    response = send_request(uri, request)
    response["access_token"] if response && response["access_token"]
  end

  def initiate_payment(phone_number, amount, reference, otp)
    uri = URI(BASE_URL)
    request = Net::HTTP::Post.new(uri)
    request["Content-Type"] = "application/json"
    request["Authorization"] = "Bearer #{@token}"

    body = {
      customer: {
        idType: "MSISDN",
        id: "784310088",
        otp: "715255"
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
    ap "*"*10
    ap request.body
    ap "*"*10
    send_request(uri, request)
  end

  private

  def send_request(uri, request)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    response = http.request(request)
    ap "*"*100
    ap response
    ap response.body
    ap "*"*100
    JSON.parse(response.body) rescue nil
  end
end
