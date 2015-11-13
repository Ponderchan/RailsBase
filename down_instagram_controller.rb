class DownInstagramController < ApplicationController
	require 'nokogiri'
	require 'open-uri'

	def down_img
		# instagram 用户名
		user_name = "chilinglin"
		if !params[:user_name].blank?
	      user_name = params[:user_name]
	    end

		# 需要获取照片的链接
		@site_url = "https://instagram.com/#{user_name}/"

		# 返回结果保存的数组
		@data = []
		get_instagram_data(@site_url)	
		# render json: @data
	end

	private
	# 获取图片数据，下一页的数据获取方式为 链接＋?max_id=本页获取的最后一条记录的id	
	def get_instagram_data(str_href)
		doc_html = Nokogiri::HTML(open(str_href))
		# p doc_html
		# doc_html.css('.-cx-PRIVATE-Photo__image').each do |img_tag|
		# 	p img_tag[:src]
		# end
		# p doc_html.css('script').text
		# p JSON.parse(doc_html.css('script').text)
		
		# 获取页面中用于渲染节点的数据		
		str_js = doc_html.css('script').text.to_s
		# js数据进行截取，使用正则表达式方式
		# 参考链接http://www.cnblogs.com/puresoul/archive/2011/11/29/2267938.html
		str_js = /window._sharedData =.*?;/.match(str_js)
		# p str_js
		
		# 获取页面中图片部分的数据		
		per_page_data = JSON.parse(str_js.to_s.gsub("window._sharedData =","").gsub(";",""))["entry_data"]["ProfilePage"][0]["user"]["media"]["nodes"]
		per_page_data.each do |item|
			# 对数据进行过滤，防止加载重复的数据
			if @data.find{|tem| tem["id"]==item["id"]}.blank?
				@data.push(item)
			end			
		end		

		# 判断返回的数据，进行下一页数据的获取
		if !per_page_data.blank?
			str_href = @site_url + "?max_id=#{per_page_data.last["id"]}"
			get_instagram_data(str_href)
		end
	end
end

