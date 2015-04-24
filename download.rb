def download_img(img_url)
    img_file = open(img_url){|f|f.read}
    file_name = img_url.split('/').last
    puts file_name
    open("public/book/"+file_name,"wb"){|f|f.write(img_file)}
end
