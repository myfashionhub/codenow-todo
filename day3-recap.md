# Day 3: Route - Controller - Action - View

On day three of the workshop, we learned how to render a new view in a Rails application.

## Set up Rails app
- When you create a new Ruby on Rails workspace in Cloud9, it automatically generates a Rails app for you. But if you were to start from scratch, use the following command:

```bash
$ rails new todo-app
```

- Initialize a git repository, and add Github repo as a remote.
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
get 'todos#index'               # /todos
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

## ERB (Embeded Ruby)
- The index.html.erb contains HTML code where you can also render variables and logic.
- To make a variable in your controller available in the view, you must declare it as an instance variable (with the @ symbol).

```ruby
    def show
        id = params[:id]

        @todo = {
            id: id,
            name: 'My task',
            description: '',
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

    def index
        # This is a code block inside method declaration

        if params[:id] == '1'
            # This is a code block inside the if conditional
            @todo = {name: 'Todo 1'}
        elsif params[:id] == '2'
            @todo = {name: 'Todo 2'}
        else
            @todo = {}
        end
    end
end
```
Note that the `end` keyword should line up with the opening keyword. Lines inside a code block are indented (indent by hitting tab once, not space four times). The indentation levels help us easily identify where the code block begins and ends.

- String interpolation: To render a value inside a string, we use this symbol `#{}`. Note: we must use double quotes for string interpolation to work. (Otherwise single and double quotes are used interchangeably.)
```ruby
@code_word = "#{params[:code]} #{params[:word]}"
```

- Declare a hash: Hash is a type of object in Ruby that contains keys and values.
```
a_hash = {
    key1: 'Value 1', # Note: no space between key1 and :
    key2: 'Value 2',
    multi_word_key: 'Value 3'
}
```
To access the value of a key, you'd write:
```
a_hash[:key1]
```
In this case `:key1` is called a symbol. Similar to variables, symbols are also snake_case.

[Day one recap](https://github.com/myfashionhub/myfashionhub.github.io/blob/master/1-dayone.md)
