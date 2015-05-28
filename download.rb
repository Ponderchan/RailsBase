module CommonHelper

  require 'nokogiri'
  require 'open-uri'

  def down_load_xmz
    site_url = "http://www.mzitu.com"

    for index_page in 1..141
      doc_html = Nokogiri::HTML(open(site_url+'/share/comment-page-'+index_page.to_s))
      doc_html.css("#comments p img").each do |item_img|
        puts item_img[:src]
        download_img(item_img[:src])
      end
    end
  end

  ########下载图片
  def download_img(img_url)
    begin
      img_file = open(img_url) { |f| f.read }
      file_name = img_url.split('/').last
      #puts file_name
      open("public/meizi/"+file_name, "wb") { |f| f.write(img_file) }
      return "/public/meizi/"+file_name
    rescue => err
      puts err
      return ''
    end
  end

end
