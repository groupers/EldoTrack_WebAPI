# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
user1= User.create(name: 'admin', email: 'dev@mail.com', password: 'password', token: 'a102938012938')
page1= Page.create(host: 'localhost', path: '/main_click_share_v2.html', href: 'https://localhost:3000/main_click_share_v2.html')
UserPage.create(user_id: user1.id, page_id: page1.id)
page2b= Page.create(host: 'local', path:'/Users/Phil/Desktop/ELDERLY/javascript/main_click_share_v2.html', href: 'file:///Users/Phil/Desktop/ELDERLY/javascript/main_click_share_v2.html')
page3b= Page.create(host: "www.google.be", path:'/', href: "https://www.google.be/")
page1= Page.create(host: 'localhost', path: '/main_click_share_v2_c.html', href: 'https://localhost:3000/main_click_share_v2_c.html')

UserPage.create(user_id: user1.id, page_id: page2b.id)
UserPage.create(user_id: user1.id, page_id: page3b.id)
