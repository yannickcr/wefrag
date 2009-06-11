xml.instruct! :xml, :version => 1.0, :encoding => 'UTF-8'
xml.xrds :XRDS, 'xmlns:xrds' => "xri://$xrds",
  'xmlns:openid' => "http://openid.net/xmlns/1.0",
  'xmlns' => "xri://$xrd*($v*2.0)" do

    xml.XRD do
      xml.Service :priority => 0 do
        xml.Type OpenID::OPENID_IDP_2_0_TYPE
        xml.URI openid_server_url
      end
    end
end
