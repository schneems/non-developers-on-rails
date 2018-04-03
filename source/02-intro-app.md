## Prequel

If you didn't already follow the instructions in the previous section to generate a rails app named `my_bank_app` do so now. We'll wait. You should also be in that directory

```
:::> $ rails _5.1.6_ new my_bank_app
:::> $ cd my_bank_app
```

If you still have your server running from the last section, you may need to open up a new command line tab. On a mac you can do that by pressing CMD+T.

When you type in a command, make sure you always see the `$` in your own command line, if you're entering in text and it doesn't appear to be doing anything, you may accidentally be inside of a server tab.

Navigate to the same directory as `my_bank_app` in this new tab using `cd`. If you don't remember how to get to that directory you can stop your server by pressing `Control+C` (note that it's Control and not CMD this time) inside of the server window. Once you've done that you can get the current directory by running `$ pwd`.

Verify that you're in the `my_bank_app` by running this command and verifying you get the same output:

```sh
:::>> $ bin/rails test
```

> Note: We'll be using `bin/rails` from now on. This is because you now have a `bin` directory that has a `rails` command inside of it.

> Extra: This test command is used by developers to ensure the validity of their code. Most good developers will write automated tests for new features as they build them. We won't be writing tests for now.

This verifies that you're in the correct directory.

## Make your first model

The first thing we're going to do is create a model. In programming a model is an abstract concept that represents somepart of your logic. A model should always be a noun (i.e. a person, place or thing). In this case we'll start with a `user` model (as is typical of most web apps).

Rails comes with a powerful command line tool for generating boilerplate code. It will save us a lot of typing and potential errors, however it does perhaps too much and is too "magical". We'll look at some of the output and in a later section do some of these operations manually.

Run this command, and note that `user` is not plural (i.e. does not end in an "s"):

```sh
:::>> $ bin/rails generate scaffold user name:string
```

This command tells rails to use the `generate` command. What are we generating? Rails has the concept of a "scaffold" that contains a model, view, controller and routes (which we'll get into later). We're telling the scaffold that we want to name our model `user` and that user has one field a `name`. That `name` field is a string (i.e. text).

If you messed up this command, you can run `$ bin/rails destroy scaffold` and pass in the same arguments to revert.

This command did a whole lot. We'll look into it more later, but first lets test drive the feature you just added to your snazzy webapp.

While we generated a bunch of code and some configuration, we need to let our database for our app know that it needs to update to the new configuration. We can do this by "migrating" the database. This is a fancy way of saying applying new configuration.

> Extra: If you look in your `db/migrate` folder you'll see one file that contains the isntructions for our database.

To migrate the database run this command:

```
:::>> $ bin/rails db:migrate
```

While some of the output is based on a timestamp (the numbers you see before `CreateUsers:` the rest should be very similar.


Make sure that you have a server running in one of your terminal tabs. If not you can run:

```
$ bin/rails server
```

> Extra: Many of the very popular commands have shortcuts, for instance `$ rails s` is the same as `$ rails server` and `$ rails g` is the same as `rails generate`. For the sake of clarity I will always use the full command.

Now that you've verified that your server is running visit [http://localhost:3000/users/new](http://localhost:3000/users/new).

The webpage should look like this:

![](https://www.dropbox.com/s/yg71wi5x2kblefr/Screenshot%202018-03-29%2015.51.11.png?raw=1)

While it might not win any beauty contests, it's your first web app feature!

> Extra: The view for this url is at `app/views/users/new.html.erb`. We'll cover views later.

Enter in a name and press the submit button. You'll see that the browser now shows a new url `https://localhost:3000/users/1` and the name you entered shows up on the webpage. Neat!

![](https://www.dropbox.com/s/2ul7juemmndjxvl/Screenshot%202018-03-29%2015.53.32.png?raw=1)

You can click the `edit` link to change the name if you want. We want to generate at least 2 users for our banking app. Go back by clicking the back button, or by clicking the "back" link.

If you clicked the back button on the browser the first name you entered might still be in the form. Clear it out and add another name, then click submit.

![](https://www.dropbox.com/s/wfdhoonjwab92dt/Screenshot%202018-03-29%2015.56.31.png?raw=1)

Extra: Notice that instead of `user/1` the URL now points at `users/2`. This has to do with details of how we're storing our users in the database. We'll cover this in more detail later.

You can also view all your users by visting [http://localhost:3000/users](http://localhost:3000/users):

![](https://www.dropbox.com/s/hqfp903lhr39uu3/Screenshot%202018-03-29%2015.57.59.png?raw=1)

## Make a User in the Console

While the web interface is handy, it's using a bunch of generated code that we didn't write and don't understand. We'll now look at some pieces of working with Rails.

First up, we'll add a third user to our banking application via the console.

Go back to your command line, and make sure that you're not in the `rails server` tab.

Next up, start your console:

```
$ bin/rails console
Loading development environment (Rails 5.1.6)
irb(main):001:0>
```

> Note: that all console commands will start with `>`, while command line commands will start with `$`.

We're now in a programming environment, go ahead and enter in this very sophisticated command:

```
> 1+1
=> 2
```

Here the command is `1 + 1` and the output is `2`.

Now that we're sure we're in the console and it's working we are going to create a new user here. Run this ruby code in your console, feel free to replace the name "Austin" with another name of your choice:

```
> User.create(name: "Austin")
   (0.0ms)  begin transaction
  SQL (0.4ms)  INSERT INTO "users" ("name", "created_at", "updated_at") VALUES (?, ?, ?)  [["name", "Austin"], ["created_at", "2018-03-29 21:06:30.030529"], ["updated_at", "2018-03-29 21:06:30.030529"]]
   (0.9ms)  commit transaction
=> #<User id: 3, name: "Austin", created_at: "2018-03-29 21:06:30", updated_at: "2018-03-29 21:06:30">
```

If you did not get the same output go back and double check that you're using the same types of quotes (i.e. `"` versus `'`) and that each opening parens `(` has a matching closing parens `)`. Also case and pluralization matters here. `User` with a capital `U` is refering to our model that you can see in your code at `app/models/user.rb`.

If you can't seem to get any output from the above command you might have entered a mismatch quote or parens. You can run Control+C to "reset" any prior bad input.

Now that you've created another user via the console, open up your browser back to [http://localhost:3000/users](http://localhost:3000/users) and verify the user shows up on the webpage by refreshing the page.

![](https://www.dropbox.com/s/tpnz8w5t9498qo7/Screenshot%202018-03-29%2016.16.35.png?raw=1)

## Views

We've created a model, the next thing we will look at is modifying a view.

In the editor of your choice (I recommend Atom or Sublime) open your `my_bank_app` folder.

In your editor go to File >> Open and then navigate to your `my_bank_app`. Highlight that folder and click the "open" button".

![](https://www.dropbox.com/s/o5xjxilebqeld0e/Screenshot%202018-03-29%2016.28.01.png?raw=1)

Your editor should look like this with a bunch of folders on the left side including `app` and `bin`:

![](https://www.dropbox.com/s/xaz0xmr2r8ifhnx/Screenshot%202018-03-29%2016.32.22.png?raw=1)

> Note: You may be using a different theme or editor.

> Extra: You can also get the `$ atom` command line command to be available by going to Atom >> Install Shell Commands. If you do that, then you can open your project in atom by running `$ atom .` inside of your `my_bank_app` folder.

Once you've got your project open in your editor, navigate to `app/views/users/new.html.erb`. It should look something like this:

```sh
:::-> $ cat app/views/users/new.html.erb
```

It's not much to look at, but you can see that it has some html tags and some other special characters that look like this:

```erb
<%= %>
```

> Extra: In Ruby this style of a view file is known as ERB which stands for "Embedded RuBy" since we're embedding ruby code from within our HTML file.

We can put Ruby code in these tags and when the view is rendered, the Ruby code will be run.

```erb
:::>> file.append app/views/users/new.html.erb
<hr />
The time is now: <%= Time.now %>
```

Make sure you saved your file.

Now visit [http://localhost:3000/users/new](http://localhost:3000/users/new) and you should see the current time on the page:

![](https://www.dropbox.com/s/lpvv52zfixazbld/Screenshot%202018-03-29%2016.40.55.png?raw=1)

When you refresh the page, notice that the time updates.

It's a bit weird that it's only on that one page though. It would be better if the time showed up on every page, don't you think?

To do this we're going to look at changing the a layout. In Rails each view is wrapped by a layout before being rendered. You can see the global layout by looking at `app/views/layouts/application.html.erb`.

Inside of this file you'll notice the erb block that looks like this:

```erb
<%= yield %>
```

This is a keyword that lets our app know where our view will be rendered. When you visit `localhost:3000/users/new` then the yield will be replaced by the contents of `app/views/users/new.html.erb` that we just modified previously.

Before modifying the layout we will remove the code we just added to the `app/views/users/new.html.erb` file.

```erb
:::- file.remove app/views/users/new.html.erb
<hr />
The time is now: <%= Time.now %>
```

Next up we'll add it right after the `yield` but before the `</body>` of the layout:

```erb
:::>> file.append app/views/layouts/application.html.erb#13
    <hr />
    The time is now: <%= Time.now %>
```

Save your file and refresh your webpage, it should look the same. Now visit another page like [http://localhost:3000/users](http://localhost:3000/users) and you'll notice that the time follows us on all our pages.

We're done with views for now.

## Request Response Cycle

It's time to take a step back and talk about an important piece of the web. When you enter in a url into an address bar you're making a Request to the webserver to send you the data you need. The server takes the URL, decides based on the path (and sometimes other things such as logged in status) what info you need. It then sends you back a response. This response is mostly HTML that will render in your browser.

Even in fancy "single page web apps" that do not reload when you interact with them (such as google maps), a request/response cycle is still happening behind the scenes with javascript.

We've already seen this request/response cycle in action, but how did Rails know what to do when it received a request to `localhost:3000/users/new`?

> Note: The part after `localhost:3000` is known as a "path". For instance the path of `localhost:3000/users/new` is `/users/new`.

Rails knows how to map a path to a controller action. I know we haven't looked at controllers, but we will. It does this through a routes file. Open `config/routes.rb` up now:

```ruby
:::-> $ cat config/routes.rb
```

You'll see there's not much there. There is one method `resources`, this is a fancy way of generating all the routes we need for our current web app. You can see all the different paths that are generated by this route file by running:

```sh
:::>> $ bin/rails routes
```

> Note: You can also view the same output by visiting [http://localhost:3000/rails/info/routes](http://localhost:3000/rails/info/routes) which is a feature I added to Rails ;)

The output is a bit hard to parse at first. We'll look at the "URI Pattern" part. Don't worry about the format part.

If you scan the list you'll see `/users/new` which we visited to add a new user to the bank. You'll also see `/users/:id` which we saw after creating our first user when we were redirected to `localhost:3000/users/1` where in this case our `:id` is `1`.

Next to these items you'll notice another column called `Controller#Action`. Items are in that list in the format of a controller a hash (`#`) and then the action. All of ours our currently in the `users` controller with different actions.

Let's take a look at `/users/new`. This maps to the `users#new` controller.

Go ahead and open up the `users` controller. It is located at `app/controllers/users_controller.rb`.


```ruby
:::-> $ cat app/controllers/users_controller.rb  | ruby -e 'STDIN.read =~ /(.*def new.*?end)/m ; puts $1 ' | xargs -0 printf '%s\n# ...\n'
```

<!--
Ruby regex here: http://rubular.com/r/kW7w7jwdfF
then we append a # ...
-->

The "new" action is denoted by `def new`. Inside of that method you'll see code that looks like this:

```
@user = User.new
```

This is similar to the `User.create` we called in the console, but in this case a user is generated but not saved to the database. The `@user` is called an instance variable, and it's how we pass data from the controller to the view.

We already saw the file `app/views/users/new.html.erb` but we didn't look at what exactly is going on. Open that file again. You'll see a line like this:

```ruby
:::-> $ cat app/views/users/new.html.erb | grep render
```

This `render` method is telling our program that we want the contents of "form" to be rendered, and we'll also pass in the `@user` variable that was created in the controller. Where is the "form" view? In this case it's a partial view (a mini view meant to be used insde of other views). It starts with an underscore `_` it can be found in `app/views/users/_form.html.erb`

```ruby
:::-> $ cat app/views/users/_form.html.erb
```

This partial view is doing a lot that you don't need to understand yet.

If you look at this line:

```ruby
:::-> $ cat app/views/users/_form.html.erb | grep form_with
```

You can see that the `user` variable that was passed into `render`, and which came from the `@user` variable in the controller is used to generate a form.

What does all this mean? We just mentally traced a Request/Response cycle in our code. Not totally following me?

In this case a user opens a browser and visits [localhost:3000/user/new](http://localhost:3000/user/new).

Rails gets the request, sees that the path is `user/new`. It then knows from the `config/routes.rb` file to map that to the `users_controller` and the `new` action.

From there the `new` action is called. The `@user` variable is created. It's then passed to the view file `app/views/users/new.html.erb` where it's then passed to our partial view in `app/views/users/_form.html.erb` and used to generate a form.

This form is HTML that gets rendered. Rails takes that HTML and packages it up in a response. Rails then sends this response back to the user in the browser, and like magic the page renders in front of them.

It's okay if you don't totally follow all the details. We'll look a little more at each of these pieces in a bit.

Next up we will put all these pieces together by manually creating a controller, a view and routes.

## Manually make a Controller

We're going to create a controller. Previously we used `$ rails generate scaffold` this time we will use `$ rails generate controller`. It does signifigantly less magic. Let's get started run this command:

```sh
:::>> $ rails generate controller welcome
```

This generated a controller for us called "welcome". While there were a bunch of support files created, the only thing we want to look at is:

```sh
:::>> $ cat app/controllers/welcome_controller.rb
```

Not very much their right? I told you there would be less magic in this section.

The next thing we need is a way to "route" to this controller.

```ruby
:::> file.append config/routes.rb
  root to: 'welcome#index'
```

Verify that this worked by running:

```sh
:::>> $ bin/rails routes
```

You should see a `/` under the URI pattern section that points to `welcome#index`.

At this point you know what the `welcome` corresponds to. But what is `index`?

It's a controller action that we need to add. When you call it it will render `app/views/welcome/index.html.erb`. Let's add that action now:

```ruby
:::> file.append app/controllers/welcome_controller.rb#2
  def index
    @message = "Hello world"
  end
```

> Extra: In Ruby the "action" here of `index` is called a "method".

This defines our "index" action. In it we're setting the `@message` instance variable to the string "Hello world". We can use this later in the view.

You may be wondering why did we use the word `index` for our action name? By default Rails prefers actions named `index`, `show`, `create`, `update`, and `destroy`. If you look in the `app/controllers/user_controller.rb` you'll see all of them! While we could name our `welcome#index` action anything we wanted to, it's nice to be consistent. An `index` in Rails is normally a landing page while `show` is showing a specific thing.

> Extra: If you go to the user controller "index" page at [http://localhost:3000/users](http://localhost:3000/users) you'll see it's a list of all of our users. If you go to [http://localhost:3000/users/1](http://localhost:3000/users/1) this is using the `show` action and is showing only one user. You can verify you're hitting these actions by looking at your server logs `Processing by UsersController#new as HTML`.

We're almost done. We've got a route, we've got a controller, all we need is a view.


```erb
:::> file.write app/views/welcome/index.html.erb
<h1>Welcome to our Banking App</h2>

<p>
  <%= @message %>
</p>
```

You should see this on the page:

![](https://www.dropbox.com/s/9l3vhy84skb4p9d/Screenshot%202018-04-02%2012.30.25.png?raw=1)

> Note: I may switch browsers for some screenshots. You don't need to do the same.

Try changing the text in the `welcome_controller.rb` and reloading the page, what happens?

> Extra: As a challenge can you figure out a way in Ruby to make the message always be output as all caps? Hint: try [String#upcase]().

## Recap

At this point you've created a model (`User`) via a scaffold, you've manually generated a controller (`welcome_controller.rb`), it's view (`app/views/welcome/index.html.erb`), and you added a route to `config/routes.rb`. You can also roughly trace the request/response relationship to your own code (the Model, View, Controller and Routes).

That's all for today. While this banking app doesn't do much, we've laid the groundwork to start building some actual features. We'll be building off of what we did in this section, so if you're unclear about something or could not get a part to work, now is the time to go back to it.

