# Day 3: Route - Controller - Action - View

On day three of the workshop, we learned how to render a new view in a Rails application.

## Quiz
- What is Ruby? Rails?
- How do you run the Rails application?
- How do you define a route in the Rails app?
- What is a controller/action?
- How do you render a view in Rails?
- Why do you use an instance variable?
- What is the file extension erb?

## Set up Rails app
- When you create a new Ruby on Rails workspace in Cloud9, it automatically generates a Rails app for you. But if you were to start from scratch, use the following command:

```bash
$ rails new todo-app
```

- Initialize a git repository, and add Github repo as a remote. (Copy the git URL from the SSH tab in your Github repo.)
```bash
$ git init
$ git remote add origin git@github.com:username/repo-name.git
```

- To start up the Rails server:
```
$ rails s -b $IP -p $PORT
```
Note: The IP and port arguments are only required to preview your app in Cloud9. In normal development, you only need `rails s` and the application will run on localhost:3000.

## Set up route
We rely on Rails' helpful errors to know what the next step is. First we simply add routes:

```ruby
# config/routes.rb
# The text on the right is how you would navigate to each route while opening your app in the browser

root 'todos#index'              # /
get 'todos' => 'todos#index'    # /todos
get 'todos/:id' => 'todos#show' # /todos/2
```

## Set up controller
- When you have added the routes, you should get an error: `uninitialized constant TodosController`. This means you need to create TodosController.

- Rails convention is to put controller files in `app/controllers/`. The file name should be snake_case (lowercase letters separated by undescores):
```bash
$ touch app/controllers/todos_controller.rb
```

- The class name should be CamelCase (capitalize first letters of words). And the controller should inherit from ApplicationController (which is provided in `app/controllers/application_controller.rb`).
```ruby
class TodosController < ApplicationController
end
```

## Set up Action
- After creating the controller, you will run into another error `The action 'index' could not be found for TodosController`. So we define the index action:
```ruby
class TodosController < ApplicationController
    # This is also an instance method of the class TodosController
    def index
    end
end
```

## Set up View
- When you refresh the app, it should show an error `Missing template todos/index`. This is a hint for us to create a template for index in views.
```
$ mkdir app/views/todos
$ touch app/views/todos/index.html.erb
```

- In index.html.erb, you don't need to put <html> and <head> tags. This is because Rails automatically generates it for you in `views/layouts/application.html.erb`. It renders the content of your index HTML using `<%= yield %>` in between the <body> tags.
```html
<!DOCTYPE html>
<html>
<head>
  <title>Codenow Todo</title>
  <%= stylesheet_link_tag    'application', media: 'all' %>
  <%= javascript_include_tag 'application' %>
  <%= csrf_meta_tags %>
</head>
<body>
  <%= yield %>
</body>
```
- `<%= stylesheet_link_tag 'application', media: 'all' %>` generates a <link> element that links all your stylesheets to the HTML page. This is why you don't have to manually link the stylesheets like in your frontend app (quite convenient).

## What is `params`
- Params contains data that your application receives in a request. The app makes `params` available everywhere, so it is accessible in your view even though it isn't an instance variable.

```html
<!-- show.html.erb -->
<h1><%= params[:id] %></h1>
```

- `params` is a hash and you can access the values of its keys like any hash (see hash below).

- `:id` is available in params hash because we have designated it as a param in the route. (Note `todos` isn't a parameter.)
```ruby
get '/todos/:id' => 'todos#show'
```

- We can pass other parameters to the app by writing them in the query string:
```
http://todo-app-username.c9users.io/todos/1?key1=value1&key2=value2
http://todo-app-username.c9users.io/todos?code=secret&word=sauce
```
Everything after `?` is part of the query string. In this case, `key1` and `key2` are names of the keys, and their values are `value1`, `value2`. Key - value pairs are separated by `&`.

- The values rendered in the HTML should change every time you change the value of the code & word keys.
```html
Code word <%= params[:code] params[:word] %>
```

## ERB (Embeded Ruby)
- The index.html.erb contains HTML code where you can also render variables and logic.
- To make a variable in your controller available in the view, you must declare it as an instance variable (with the @ symbol).

```ruby
    def show
        @id = params[:id]
        # @todo is a hash
        @todo = {
            name: 'My task',
            description: 'A longer description of the task',
        }
    end
```

```html
<!-- show.html.erb -->

<!-- This will throw an error "undefined local variable or method 'id'" -->
<h1>Todo <%= id %></h1>

<%= @todo[:name] %>
```

## Connect index and show pages
- Instead of linking the todo items to show.html, you want to link them to the show route we made:

```html
<!-- Frontend app -->
<a href="show.html">My todo item</a>

<!-- Rails app -->
<a href="/todos/1">My todo item</a>
```
- When you navigate to '/todos/1' in the browser, the app will recognize the show route and render the show.html.erb page.

## Ruby syntax
- Keyword `end`: In Ruby, we signify the end of code blocks with the keyword `end`. Below are examples of code blocks:

```ruby
class TodosController
    # This is a code block inside the class declaration

    def show
        # This is a code block inside method declaration

        if params[:id] == '1'
            # This is a code block inside the if conditional
            @todo = {name: 'Todo 1', description: 'Task 1'}
        elsif params[:id] == '2'
            @todo = {name: 'Todo 2', description: 'Task 2'}
        else
            @todo = {
                name: 'Everything else',
                description: 'Generic description',
            }
        end
    end
end
```
Note that the `end` keyword should line up with the opening keyword. Lines inside a code block are indented (indent by hitting tab once, not space four times). The indentation levels help us easily identify where the code block begins and ends.

- String interpolation: To render a value inside a string, we use this symbol `#{}`. Note: we must use double quotes for string interpolation to work. (Otherwise single and double quotes are used interchangeably.)
```ruby
@code_word = "#{params[:code]} #{params[:word]}"
```

- Hash is a type of object in Ruby that contains keys and values.
```ruby
a_hash = {
    key1: 'Value 1', # Note: no space between key1 and :
    key2: 'Value 2',
    multi_word_key: 'Value 3'
}
```
To access the value of a key, you'd write:
```ruby
a_hash[:key1]
```
In this case `:key1` is called a symbol. Similar to variables, symbols are also snake_case.

[Day one recap](https://github.com/myfashionhub/myfashionhub.github.io/blob/master/1-dayone.md)
