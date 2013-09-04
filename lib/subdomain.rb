class Subdomain  
  def self.matches?(request)  
    request.subdomain.present? && \
    request.subdomain != 'www' && \
    request.subdomain != 'skunkwrx' && \
    request.subdomain != 'test'
  end  
end