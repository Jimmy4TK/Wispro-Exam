# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

    users = User.create([{name:'Jimmy',last_name:'Falco',password:'1234',mail:'ex@example.com'},{name:'Pedro',last_name:'Argento',password:'1234',mail:'pedro@example.com'}])
    isps = Isp.create([{name:'Claro',password:'1234'},{name:"Movistar",password:'1234'}])
    services = Service.create([{name:'30MB Fibra optica',price:'4000',description:'Internet de 30MB simetricos de fibra optica',isp_id:'1'},{name:'15MB Fibra optica',price:'1500',description:'Internet de 15MB de fibra optica',isp_id:'1'},{name:'100MB Fibra optica',price:'6000',description:'Internet de 100MB de fibra optica',isp_id:'2'}])
    user_services = UserService.create([{user_id:'1',service_id:'3'},{user_id:'1',service_id:'2'},{user_id:'2',service_id:'1'}])