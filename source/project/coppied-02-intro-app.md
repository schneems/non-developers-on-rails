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

```
:::-> $ cat app/views/users/new.html.erb
```

It's not much to look at, but you can see that it has some html tags and some other special characters that look like this:

```erb
<%= %>
```

> Extra: In Ruby this style of a view file is known as ERB which stands for "Embedded RuBy" since we're embedding ruby code from within our HTML file.

We can put Ruby code in these tags and when the view is rendered, the Ruby code will be run.

In this file go ahead and add this code:

```
:::>> file.append app/views/users/new.html.erb

The time is now: <%= Time.now %>
```
