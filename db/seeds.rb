Source.destroy_all
Source.create(name: 'Seacen Press')
Source.create(name: 'The Guardian Australia News')
Source.create(name: 'Herald Sun Breaking News')
Source.create(name: 'The Age World News')
Source.create(name: 'Billboard.com Music News')
Source.create(name: 'The Economist Business News')
Source.create(name: 'BBC Politics News')

Author.destroy_all
Author.create(name: 'Xichang(Seacen) Zhao')

Article.destroy_all
Article.create(title: 'Welcome To The Digest Made By Seacen!', date_of_publication: '20-09-2015', summary: "Enjoy and have a great time!", author:Author.find_by(name:'Xichang(Seacen) Zhao'), source:Source.find_by(name:'Seacen Press'), link:'http://www.seacen.tk/', image:'https://media.licdn.com/mpr/mpr/shrinknp_400_400/AAEAAQAAAAAAAANrAAAAJDkwMjA5NWJlLTBkZDAtNGIyYi1hN2U0LTZlMjM3YmRiN2YyNQ.jpg',tag_list:'seacen')

User.destroy_all
User.create(username: 'seacen', first_name: 'Xichang', last_name: 'Zhao', email: 'xichangzhao@outlook.com', password: 'seacen')
