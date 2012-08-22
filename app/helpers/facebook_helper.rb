module FacebookHelper
	def user_likes_page?
	  fb_request = parse_signed_request
	  return fb_request['page']['liked'] if fb_request && fb_request['page']
	end

def parse_signed_request
  if params[:signed_request].present?
    sig, payload = params[:signed_request].split('.')
    payload += '=' * (4 - payload.length.modulo(4))
    data = Base64.decode64(payload.tr('-_','+/'))
    JSON.parse( data )
  end
	rescue Exception => e
	  Rails.logger.warn "!!! Error parsing signed_request"
	  Rails.logger.warn e.message
	end

end