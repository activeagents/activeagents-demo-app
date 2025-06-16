bin/rails generate migration CreateUsers name:string email:string password_digest:string
bin/rails generate scaffold Chat name:string
bin/rails generate migration CreateMessages chat:references role:integer content:text
bin/rails generate migration CreateUsersChats user:references chat:references