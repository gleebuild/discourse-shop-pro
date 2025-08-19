# frozen_string_literal: true
require "openssl"
require "base64"
require "json"
require "net/http"
require "uri"

module WechatPay
  class Client
    API_HOST = "https://api.mch.weixin.qq.com"

    attr_reader :mchid, :appid, :serial_no, :api_v3_key, :private_key, :platform_cert

    def initialize(mchid:, appid:, serial_no:, api_v3_key:, private_key_pem:, platform_cert_pem: nil)
      @mchid = mchid
      @appid = appid
      @serial_no = serial_no
      @api_v3_key = api_v3_key
      @private_key = OpenSSL::PKey::RSA.new(private_key_pem) if private_key_pem && !private_key_pem.empty?
      @platform_cert = OpenSSL::X509::Certificate.new(platform_cert_pem) if platform_cert_pem && !platform_cert_pem.empty?
    end

    def authorization(method, path, body)
      ts = Time.now.to_i.to_s
      nonce = SecureRandom.hex(12)
      body_str = body ? body.to_json : ""
      message = [method, path, ts, nonce, body_str, ""].join("\n")
      sign = Base64.strict_encode64(@private_key.sign("SHA256", message))
      schema = "WECHATPAY2-SHA256-RSA2048"
      %(#{schema} mchid="#{@mchid}",nonce_str="#{nonce}",signature="#{sign}",timestamp="#{ts}",serial_no="#{@serial_no}")
    end

    def post(path, body)
      uri = URI.join(API_HOST, path)
      req = Net::HTTP::Post.new(uri)
      req["Content-Type"] = "application/json"
      req["Accept"] = "application/json"
      req["Authorization"] = authorization("POST", uri.path, body)
      req.body = body.to_json
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      res = http.request(req)
      JSON.parse(res.body)
    end

    def decrypt_resource(ciphertext, associated_data, nonce)
      key = @api_v3_key
      cipher = OpenSSL::Cipher.new("aes-256-gcm")
      cipher.decrypt
      cipher.key = key
      cipher.iv = nonce
      cipher.auth_data = associated_data
      data = Base64.decode64(ciphertext)
      cipher_text = data[0...-16]
      tag = data[-16..-1]
      cipher.auth_tag = tag
      cipher.update(cipher_text) + cipher.final
    end

    def verify_signature(signature, timestamp, nonce, body)
      return false unless @platform_cert
      message = [timestamp, nonce, body, ""].join("\n")
      pub = @platform_cert.public_key
      pub.verify(OpenSSL::Digest::SHA256.new, Base64.decode64(signature), message)
    end
  end
end