#!/usr/bin/env ruby
# coding: utf-8

require "mechanize"
require "sqlite3"
require "net/smtp"
require "yaml"

begin
	path = File.expand_path(File.dirname(__FILE__))
	SETTINGS = YAML::load(open(path+"/userinfo.conf"))
rescue
	puts "Config file load failed."
	exit
end

def sendmail(from, to, subject, body)
  body = <<EOT
From: #{from}
To: #{to}
Subject: #{subject}
Date: #{Time::now.strftime("%a, %d %b %Y %X %z")}
Content-Type: text/html; charset=UTF-8
 
#{body}
EOT
  Net::SMTP.start("localhost", 25) do |smtp|
    smtp.send_mail body, from, to
  end
end


USER = SETTINGS["user"]
PASS = SETTINGS["password"]

MAIL_FROM = SETTINGS["mail_from"]
MAIL_TO   = SETTINGS["mail_to"]
MAIL_SUBJECT = SETTINGS["mail_subject"]

agent = Mechanize.new
agent.user_agent_alias = "Mac Safari"
agent.get("http://cms.suzuka-ct.ac.jp/cc/course/login/index.php")
agent.page.form_with(id: "login") do |form|
	form.field_with(name: "username").value = USER
	form.field_with(name: "password").value = PASS
	form.click_button
end

sleep 3
agent.get("http://cms.suzuka-ct.ac.jp/cc/course/")

messages = Array.new
agent.page.search("div.block_crtv_watch_newsview").each do |message| 
	t = message.children[1].text.strip!
	messages.push t
end

agent.page.link_with(text: "ログアウト").click

db = SQLite3::Database.new(path+"/Store.db")
db.execute("CREATE TABLE IF NOT EXISTS messages (id INTEGER PRIMARY KEY, message TEXT NOT NULL);") 

db.execute("select * from messages").each do |data|
	if messages.index(data[1]) == nil then
		db.execute("delete from messages where id = #{data[0]}")
	end
end

db_messages = db.execute("select message from messages")
db_messages.flatten!
messages.each do |message|
	if db_messages.index(message) == nil then
		db.execute("insert into messages values(:id,:message)", :message => message)
		sendmail(MAIL_FROM, MAIL_TO, MAIL_SUBJECT, message)
	end
end

db.close





