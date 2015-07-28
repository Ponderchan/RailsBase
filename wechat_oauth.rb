#公众号的唯一标识 
$appid = '自己公众账号的appid'  
#公众号的appsecret 
$app_secret ='自己公众账号的appsecret' 
def wx_oauth2    
    #授权后重定向的回调链接地址，请使用urlencode对链接进行处理  
    redirect_url = "http://test.lixuanqi.com/common/oauth_back"   
    #应用授权作用域，snsapi_base （不弹出授权页面，直接跳转，只能获取用户openid），snsapi_userinfo （弹出授权页面，可通过openid拿到昵称、性别、所在地。并且，即使在未关注的情况下，只要用户授权，也能获取其信息）  
    scope = 'snsapi_userinfo'   #非必须参数 重定向后会带上state参数，开发者可以填写a-zA-Z0-9的参数值，最多128字节  
    state = 'yuluo'  
    str_url = "https://open.weixin.qq.com/connect/oauth2/authorize?appid=#{$appid}&redirect_uri=#{redirect_url}&response_type=code&scope=#{scope}&state=#{state}#wechat_redirect"  redirect_to str_url 
end
 
 
####回调页面

def oauth_back   

    page_head_data('获取微信用户信息','','') 
    if params[:code].blank? 
        render :text => 'err'  
    else  
        str_url = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=#{$appid}&secret=#{$app_secret}&code=#{params[:code]}&grant_type=authorization_code"  token_data = JSON.parse(RestClient.get(str_url)) 
        Rails.logger.info(token_data) 
        if token_data["errcode"].blank? 
            Rails.logger.info "access_token值为:"+token_data["access_token"] 
            str_user_info_url = "https://api.weixin.qq.com/sns/userinfo?access_token=#{token_data["access_token"]}&openid=#{token_data["openid"]}&lang=zh_CN"  Rails.logger.info str_user_info_url  
            str_user_info = RestClient.get(str_user_info_url) 
            Rails.logger.info str_user_info.to_s 
            #render json:  str_user_info   
            @user_info = JSON.parse(str_user_info)         
        else   
            Rails.logger.info token_data.to_s 
            render json: token_data  
        end    
    end
 end
