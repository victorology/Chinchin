class Subdomain  
  def self.matches?(request)  
    request.subdomain.present? && request.subdomain != 'www'
    request.subdomain.present? && request.subdomain != 'skunkwrx'  
    request.subdomain.present? && request.subdomain != 'test'
  end  
end