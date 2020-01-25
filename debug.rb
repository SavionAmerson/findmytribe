# ruby script

s = "hey savion how's it going? glad to chat today"

puts s

s2 = s.gsub(/\?.*/, "")

puts s2

s.gsub!(/\?.*/, "")

puts s

url = "linkedin.com/in/thisguy"
url2 = "linkedin.com/in/thisguy?commenturn=929269812683539856"

puts url == url2

puts url == url2.gsub(/\?.*/, "")