# Day 4: Create Read Update Delete (CRUD)
On day 4, we add the database to our Rails application and build a fully functioning CRUD app.

## Set up database
First, we have to make sure we have the correct setup to create the database:

- Edit Gemfile: change gem `sqlite3` to `pg` (for PostgreSQL).
```
gem 'pg'
```

- Edit database.yml. YAML is a human-readable markup language that is often used to set configurations. Like a Ruby hash, YAML is written as key-value pairs.
You want to change the adapter from `sqlite3` to `postgresql` as well as the name of the databases.
```yml
default: &default
  adapter: postgresql
  pool: 5
  timeout: 5000

development:
  <<: *default
  database: codenow_todo_development

production:
  <<: *default
  database: codenow_todo_production
```

- You need to start the postgresql service before being to create a db:

```bash
$ sudo service postgresql start
```

- Create the db:
```bash
# Using Rails' rake:db command
$ rake db:create

# Using postgresql createdb command
$ createdb todo_app_development
```

## Create table
Here is an analogy for the database, table and data:
```
bookstore    => database
bookshelves  => tables
shelves      => rows
data fields  => books
```
Each data model inserted into the SQL table is a row.

- Migration: We create and update tables using migrations. Migration files (with timestamps, a up and a down action) help us keep track of the changes to the database over time. The down action enables us to undo the changes to the migration if necessary.

```bash
$ rails g migration create_todos
```

- The above command generates a migration file, and we have to specify what we want to do in the migration. In this case, we want to define columns/fields for the todos table:
```ruby
class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.string :description
      t.integer :duration
      t.boolean :complete
      t.timestamps null: false
    end
  end
end
```
Each column of the table needs a name (e.g. `:name`) and data type (e.g. `string`).

- `def change` is a short way to define both the up and down action. It's implied that when we reverse the migration, we simply drop (delete) the table .

- First, check the `db/schema.rb` file. It should be almost blank. Then we run migration:
```bash
$ rake db:migrate
```
Running the migration should update your `db/schema.rb` to reflect the state of your database.
Note: If you want to make changes to the schema, you must do it via a migration. Editing `schema.rb` won't do anything since it's automatically generated (overwritten) when running migrations.

## Working with the model
Now that we have a database to save our data, we can interact with it. ActiveRecord and the Rails console allow us to easily create and update data.

- First you have to define the model class:
```
class Todo < ActiveRecord::Base
  validates :name, presence: true
end
```

- Then you can create a new todo in the Rails console.
```bash
$ rails c
> Todo.create(name: 'My todo', duration: 15, complete: false)

# Update the todo
> todo = Todo.find(1)
> todo.update(name: 'Another todo')

# Create an invalid todo
# This todo won't be created because it doesn't have a required name param
> Todo.create(duration: 30)
```
# CRUD
## Create
- Create data using a form: The form should have an input for all the fields of a todo. Don’t forget authenticity token (this is a security measure for the app). Add the below form to your `index.html.erb`.

```html
<form action=”/todos” method=”POST”>
  <input type=”hidden” name=”authenticity_token”
       value=”<%= form_authenticity_token %>”>
  <input type=”text” name=”name”/>
  <input type=”text” name=”description”/>
  <input type=”number” name=”duration”/>
  <input type=”checkbox” name=”complete”/>
  <input type="submit" value="Create todo" />
</form>
```

- When you submit this form, you should get `No route for POST /todos` error. This is our clue to add the route:

```ruby
# config/routes.rb
post 'todos' => 'todos#create'
```

- After adding the route, submitting the form should result in a `'create' action not found` error. So we go ahead and add the action:

```ruby
# todos_controller.rb
def create
  todo = Todo.create(
    name: params[:name],
    description: params[:description],
    duration: params[:duration],
    complete: params[:complete],
  )
  redirect_to "/todos/#{todo.id}"
end
```
The params are available because we sent it via the form. The names of the keys (`:name, :description, :duration, :complete`) correspond to the name we gave the input (`<input type=”text” name=”name”/>`).

- After creating the todo, we want to redirect to the show page.

## Read
- Next we need to update the show action and view:

```ruby
# todos_controller.rb
def show
  @todo = Todo.find(params[:id])
end
```

- Render the todo in the show page using erb:
```html
<p>Task: <%= @todo.name %>” /></p>
<p><%= @todo.description %></p>
<p>Estimated time to complete: <%= @todo.duration %> mins</p>
<p>Completed: <%= @todo.complete %></p>
```

## Update
- On the todo show page, we want to have the option of updating it. So we need a form, which is very similar to the create form:

```html
<form action=”/todos/<%= @todo.id %>” method=”POST”>
  <input type=”hidden” name=”authenticity_token”
       value=”<%= form_authenticity_token %>”>
  <input type=”text” name=”name”
    value=”<%= @todo.name %>” />
  <input type=”text” name=”description”
    value=”<%= @todo.description %>" />
  <input type=”number” name=”duration”
    value=”<%= @todo.duration %>" />
  <input type="checkbox" name="complete"
    <%= @todo.complete ? "checked" : "" %> />
  <input type="submit" value="Update todo" />
</form>
```
- The update form's action should be different from that of the create form. Also, we want to render the existing value of each field using the HTML `value` attribute. The checkbox input is a special case. If you put a `checked` attribute in the input, the box is checked, no checked attribute means it's not checked.

- We also need a corresponding route and action defined:
```ruby
# routes.rb
post 'todos/:id' => 'todos#update'
```

- The update action is also similar to the create action except:
  - We first find the todo using the id params.
  - We use the `update` method instead of create.
```ruby
# todos_controller.rb
def update
  todo = Todo.find(params[:id])
  todo.udpate(
    name: params[:name],
    description: params[:description],
    duration: params[:duration],
    complete: params[:complete],
  )
  redirect_to "/todos/#{todo.id}"
end
```

## Read (all)
- After creating and updating todos, we want to be able to see the list of all our todos on one page. So we go back and edit the index action and page:

```ruby
# todos_controller.rb
def index
  @todos = Todo.all
end
```

- In `index.html.erb` we render all the todos using a loop:
```html
<ul>
<% @todos.each do |todo| %>
  <li>
    <a href="/todos/<%= todo.id %>">
      <%= todo.name %>
    </a>

    <!-- Add delete form here -->
  </li>
<% end %>
</ul>
```
Clicking on each todo should redirect to its show page.

## Delete
- Deleting a todo requires a very simple form. You can add this to the todo `<li>` on your index page, or to the show page:
```html
<form action="/todos/<%= todo.id  %>/delete" method="POST">
  <input type="hidden" name="authenticity_token" value="<%= form_authenticity_token %>">
  <input type="submit" value="Delete"/>
</form>
```

- You will also need a route and action for it:
```ruby
# routes.rb
post 'todos/:id/delete' => 'todos#destroy'
```

```ruby
# todos_controller.rb
def destroy
  Todo.find(params[:id]).destroy
  redirect_to '/'
end
```

### POST vs GET
- Why do we use get requests in some cases and post in others? GET requests often correspond to reading data (i.e. view list of todos, view one todo). Whereas POST requests are used to modify data (e.g. create new doto). PUT and DELETE requests are used to update and delete data. However, HTML from doesn't support these actions, so we use POST request instead.

- Routes: Some of the routes look similar. However, the combination of the request type (get/post) and route name (`'/items', /items/:id'`) has to be unique:
```ruby
  # This works
  get '/items/:id'    => 'items#show'
  post '/items/:id'   => 'items#update'

  # This doesn't work
  get '/items/:id'    => 'items#show'
  get '/items/:id'   => 'items#edit'
```
