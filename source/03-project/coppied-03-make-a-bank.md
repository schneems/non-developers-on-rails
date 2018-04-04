## The Saga Continues

You're welcome to use the banking app from the last project, or if you want you can create a new one, though if you do that I recommend naming it something different.

If you're using your app from last time you can skip this section.

Here's the short version of what you'll need.

```
:::>- $ rails _5.1.6_ new my_bank_app
:::>- $ cd my_bank_app
:::>- $ bin/rails generate scaffold user name:string
:::>- $ bin/rails db:migrate
```

In one console tab start your server (if one isn't already running).

```
$ bin/rails server
```

Make sure you have at least 3 users in your app. You can do this in the `$ bin/rails console` or via the web interface at [http://localhost:3000/users/new](http://localhost:3000/users/new)

```
:::-- $ rails runner 'User.create(name: "Schneems"); User.create(name: "Ruby"); User.create(name: "Cinco")'
```

These sections are not 100% required, but will be nice to have the app looking the same as mine

```erb
:::>> file.append app/views/layouts/application.html.erb#13
    <hr />
    The time is now: <%= Time.now %>
```

Generate your welcome controller, route and view:

```sh
:::>- $ rails generate controller welcome
```

```ruby
:::>> file.append config/routes.rb#2
  root to: 'welcome#index'
```

```ruby
:::>> file.append app/controllers/welcome_controller.rb#2
  def index
    @message = "Hello world"
  end
```

```erb
:::>> file.write app/views/welcome/index.html.erb
<h1>Welcome to our Banking App</h2>

<p>
  <%= @message %>
</p>
```

Now that we're on the same page, let's add some features.

## Accounts

Having a user model is all fine and good, but what about an account? When I log into my banking app, I have a savings account and a checking account. In fact I have have multiple checking and savings accounts. Some banks offer money market accounts, certificate of deposits, and more.

To build this into our app I'm going to give you the commands to run through, and then we're going to go back and look at what happened.

The second model (after `User`) we will add to our app is the `Account` model. If you'll remember earlier a good model should always represent a noun (a person, place, or a thing). An `account` might be an abstract concept, but it is certainly a thing™️.

Previously when we made our `User` we gave it one attribute: a name. What kinds of attributes would an account have?

One that comes to mind right away is that an account would have an associated "balance".

We'll also need a way to say that an account belongs to a specific user. In Rails we can do this from the generate command by specifying "references".

```sh
:::>> $ bin/rails generate model account balance:decimal user:references
```

To recap this command `generate` creates things. We're telling it to create a model, which will also generate a database migration. We want it to have a `balance` we our balance can contain decimal numbers like `19.20` so we want to use `decimal` instead of `integer`. Finally we want it to maintain a reference to the user that owns the account.

Your account model should look like this:

```ruby
:::>> $ cat app/models/account.rb
```

Not a whole lot going on. The only new thing is:

```ruby
:::-> $ cat app/models/account.rb | grep belongs_to
```

This is how we let Rails know the relationship betwen a `User` and an `Account` instance. We'll talk about this a bit more in a bit.

What happened to our balance? Where is that data stored? I glossed over this with the user previously, but it's kept inside of our database. To understand better, we will look at the migration file.

Open the folder `db/migrate`, you should see two files:

```
:::>> $ ls db/migrate/
```

> Note: Your file name numbers will be different than mine, Rails uses a timestamp for the file name to help keep the migrations in order.

Take a look that ends in `create_accounts.rb`:

```ruby
:::-> $ ls -Ad1 db/migrate/* | grep create_accounts.rb | xargs cat
```

This file contains instructions in Ruby to tell the application how to make a new database table for our Account model, and what fields we want. You can see this is where we are defining our balance:

```ruby
:::-> $ ls -Ad1 db/migrate/* | grep create_accounts.rb | xargs cat | grep balance
```

And here is where we are defining telling our database that this model has a relationship with the `User` model:

```ruby
:::-> $ ls -Ad1 db/migrate/* | grep create_accounts.rb | xargs cat | grep user
```

Go ahead and migrate your database by running:

```sh
:::>> $ bin/rails db:migrate
```

We did this before after we added our `User` model. At this time we've got an account model. It can hold a balance, and it can be associated with a user. Not bad for one `$ bin/rails generate` command and a database migration.

This does leave a question: What exactly is a database, what's a database migration, and why should I care?

## Databases run the world

If you take away one thing from this course, it will hopefully be that databases are really important and most any product feature will need a datastore of some kind or another.

At a high level a database stores information. We're already using it to save the names of our users. Most databases are called "relational" databases. That is, not only can they store data (a user's name), but they can also store relationships between types of data (an account can belong to a user).

One way to think about a database is to imagine a giant stored excel spreadsheet. In this analogy a worksheet represents a database table. We have one table for users and one table for accounts. In our tables we will have rows and columns (just like in excel). The columns are named, for instance in the user table we have a column named "name", and in the accounts table we have a column named "balance". So far so good.

Now every time you create a new user, you add a new row to the user table.

That's just to help with a visualization. In reality a database does much more. You don't need to understand much of it for now, but one thing you should have at least a tiny understanding of is how a database stores relationships.

## Database Relationships

When I added users to my app I added one named `"Ruby"` and one named `"Cinco"`. If you were building a feature that lets you transfer money from one account to another, you could tell the app "Take the account with a user name `cinco` and transfer $5 to the account with user name `Ruby`". On the surface that seems fine, but what if someone changed their name. What if Cinco got changed their name to `Siete`? If they did that in the middle of a transfer using the above pseudo code, then our transfer would fail. We need some way to reference database entries in a way that won't change. For this purpose each entry also has a "primary key".

> Note: You don't need to run this command directly, but I'll give it to you in case you're interested.

Here a representation of how we're storing data for the first two users in the users table:

```
:::>> $ echo "SELECT * from users LIMIT 2;" | bin/rails dbconsole --header=on --mode=column
```

> Extra: The `echo` command outputs a string to standard out. The `SELECT * from users LIMIT 2;` above is known as SQL and tells our database what we want. We're passing it to the `$ bin/rails dbconsole` command via a pipe `|`. The flags `--header=on --mode=column` are used to format the output.

The primary key of each user is under the column labeled `id`. By default Rails uses incrementing ids that are integers.

You'll also notice that there's a `created_at` and `updated_at` column that we didn't tell Rails to make. It added them for us by default.

If you remember our migration from accounts, we specified `foreign_key: true`:

```ruby
:::-> $ ls -Ad1 db/migrate/* | grep create_accounts.rb | xargs cat | grep user
```

We talked about a primary key, but what is a foreign key? Each new account needs a way to reference its user. Since each user has a primary key, we can reference that same key to define the relationship.

That's a hard concept to visualize. It's much simpler seen in code. Right now you don't have any accounts. Let's make one. Open up a console:

```sh
$ bin/rails console
```

> Note: In some of my output you might see `Switch to inspect mode.` due to the way i'm generating the output for this doc. You won't see that in your output. Also there might be some slight differences, but overall the outputs should be of a similar format.

We're going to grab our first user:

```
> user = User.first
:::-> $ bin/rails runner "puts User.first.inspect"
```

What is the ID of this user?

```
> user = User.first
> puts user.id
:::-> $ bin/rails runner "puts User.first.id"
```

We can now create an account that references this user:

```
> user = User.first
> Account.create(balance: 50.0, user_id: user.id)
:::-> $ bin/rails runner "puts Account.create(balance: 50.0, user_id: User.first.id).inspect"
```

To prove it, we can get a reference of our original user from the account we just created:

```
> account = Account.first
> puts account.user
:::-> $ bin/rails runner "puts Account.first.user.inspect"
```

Notice that the ID of the user returned is the same as the foreign key in `account.user_id`.

What happens if we try to get the account from the user?

```
> user = User.first
> puts user.accounts.first
:::-> fail.$ bin/rails runner "puts User.first.accounts.first.inspect"
```

Looks like there's an error. If you remember there was an extra line in the `app/models/account.rb` that told Rails that it belonged to a user, however we didn't tell Rails how a user is related to an account. Let's do that now.

```
:::>> file.append app/models/user.rb#2
  has_many :accounts
```

Each relationship has to go two ways. In this case an account belongs to a user, and the user can have many accounts. Rails can do quite a few different variations of relationships. Has one and belongs to is likely the most common.

Start your console again if you stopped it. If you still have the old console open you'll need to tell it to reload your code so it knows something changed. You can run:

```
> reload!
```

Now try that code that failed previously:

```
> user = User.first
> puts user.accounts.first
:::-> $ bin/rails runner "puts User.first.accounts.first.inspect"
```

Worked like a charm!

### Add a view

Now that we've got a new model and we understand relations, let's do something with it in a view.

I'm assuming that you already created a view, controller, and added a route for "Welcome".

Since we don't have any kind of a login behvior yet, we'll pretend that the first user in our database is the one logged in. To do this, add a line to your welcome controller:

```ruby
:::-- file.remove app/controllers/welcome_controller.rb
  def index
    @message = "Hello world"
  end
```

```ruby
:::>> file.append app/controllers/welcome_controller.rb#
  def index
    @message = "Hello world"
    @user = User.first
  end
```

Now in your view, show the user's name:


```erb
:::>> file.write app/views/welcome/index.html.erb
<h1>Welcome to our Banking App <%= @user.name %></h2>

<p>
  <%= @message %>
</p>
```

When you reload your home page it should look a little like this:

![](https://www.dropbox.com/s/o7wl6hb08ae98bf/Screenshot%202018-04-02%2014.25.13.png?raw=1)

Now let's add some information about the accounts. To do this we're going to loop through each account and output its balance.

```erb
:::>> file.write app/views/welcome/index.html.erb
<h1>Welcome to our Banking App <%= @user.name %></h2>

<p>
  <%= @message %>
</p>

<div>
  You have <%= @user.accounts.count %> accounts.

  <ul>
    <% @user.accounts.each do |account| %>
      <li>$ <%= account.balance %></li>
    <% end %>
  </ul>
</div>
```

If you made more than one account for your user by accident (or on purpose) then they will show up on this page. Depending on the number of accounts, the output should look like this:

![](https://www.dropbox.com/s/udil9z3mqt89rjt/Screenshot%202018-04-02%2014.29.53.png?raw=1)


If you get an error try to go back and copy the code character for character. You can also use any error messages you get to try to tell you where the problem is.

I introduced a new format in this view that you've not seen before. That `do ||` format is called a block.

## Block syntax

To understand what's going on in the above view, you need to have a vauge idea of what a block does. In your rails console or in a new tab with `$ irb` you can run this code:

```ruby
[1, 2, 3].each do |x|
  puts "Hello #{x}"
end
:::-> $ ruby -e '[1, 2, 3].each do |x|; puts "Hello #{x}"; end; nil'
```

The `each` command takes the input (in this case an array with three numbers) and one at a time it passes them to the variable inside of the pipes `|x|`. Then the code inside of the block (whatever comes before the end) gets executed with each of the elements.

Feel free to play around a bit if you want here. Try adding more numbers to the array, what happens? Try adding a string like `'Austin, Tx'` to the array, what happens?

While a block might look weird, and have a strange name, it's usually just a way of iterating over data.

Back to our app.

## Transactions

While the app now has users, and it has accounts, it does not have any way of tranferring money between accounts. What do you think we need to add to make this happen?

If you guessed "another model", you would be right. What do you think we should call a model that lets us transfer money from accounts? How about a 'transaction' model.

When data is transfered between accounts what information do we need? First we need to reference two accounts where the money is being transfered to and from. Next we need to store the amount of money being transfered.

To accomplish this I want to have a `amount` column, a `to_account` reference, and a `from_account` reference.

```sh
:::>> $ bin/rails generate scaffold transaction from_account:references to_account:references amount:decimal
```

> Note: We are back to using `scaffold` rather than just generating a model.

Unlike previously where rails knew that we had a `User` model and so it added a `belongs_to` code to the `transaction` model, Rails does not know what a `to_account` is. We must tell Rails that a `to_account` and a `from_account` are both `Account` models.

First we need to modify our migration open up your migration file in `db/migrate` that ends with `_create_transactions.rb`.

It should look like this:

```ruby
:::-> $ ls -Ad1 db/migrate/* | grep create_transactions.rb | xargs cat
```

First remove these lines:

```ruby
:::>> file.remove db/migrate/*_create_transactions.rb
      t.references :from_account, foreign_key: true
      t.references :to_account, foreign_key: true
```

Then add these lines:

```ruby
:::>> file.append db/migrate/*_create_transactions.rb#4
      t.references :to_account, index: true, foreign_key: { to_table: :accounts }
      t.references :from_account, index: true, foreign_key: { to_table: :accounts }
```

Next up migrate the database:

```sh
$ bin/rails db:migrate
```


After the database is migrated we need to let Rails know about our association:

```ruby
:::>> file.append app/models/transaction.rb#2
  belongs_to :to_account, class_name: "Account"
  belongs_to :from_account, class_name: "Account"
```

In this case we had to specify a class name in addition to the name of the column.

Really quick, before we go any further - make sure that there are at least two users with at least one accont each. In your `$ rails console` you can run:

```
> Account.create(balance: 50, user_id: 1)
> Account.create(balance: 50, user_id: 2)
:::-> $ echo "Account.create(balance: 50, user_id: 1); Account.create(balance: 50, user_id: 2)" | rails c | sed -e '/Loading development environment/d' | sed -e '/Switch to inspect mode./d'
```

Now if you go to [http://localhost:3000/transactions/new](http://localhost:3000/transactions/new) you'll see a page that looks like this:

![](https://www.dropbox.com/s/slzdrfk5eqyv3f2/Screenshot%202018-04-02%2015.04.57.png?raw=1)

If you try to enter some account IDs and an amount, it will work, but nothing will be transfered. Why not? Rails has no idea that we intended that behavior, we'll have to manually program that logic. Don't worry though, it's pretty short.

To do this we will use a "callback" in the transaction model.

```ruby
:::>> file.append app/models/transaction.rb#3
  after_commit :transfer_the_dough

  def transfer_the_dough
    from_account.balance = from_account.balance - amount
    to_account.balance = to_account.balance + amount
    from_account.save!
    to_account.save!
  end
```

This code is saying that after the database record is created (that's our `after_commit` callback) run the method `transfer_the_dough`. Then inside of that method we're performing our logic of removing the transfer amount from one account and adding it to another account. Finally we're going to save both the from and true accounts back to the database.

Go back to your web browser to [http://localhost:3000/transactions/new](http://localhost:3000/transactions/new)

In the "From account" field enter `1`. In the "To account" field enter `2`. Put any numeric value in the "Amount" field that is. Submit the form and you should see a page that looks like this:

![](https://www.dropbox.com/s/9v9xt02bjdbi4i4/Screenshot%202018-04-03%2008.24.46.png?raw=1)

This means that the transaction was created. This page isn't terribly pretty, or helpful. While it does show the amount transfered, the representation of the to and from accounts doesn't mean much.

Verify that the balance of your accounts using the Rails console:

```
$ bin/rails console
> puts Account.where(id: 1).first.balance.to_digits
> puts Account.where(id: 2).first.balance.to_digits
```

The first account should have a lower balance and the second account should have a greater balance.

You can also see a change in balance looking at your welcome page [http://localhost:3000/](http://localhost:3000/):

![](https://www.dropbox.com/s/siow659v6v1su9r/Screenshot%202018-04-03%2008.30.56.png?raw=1)

> Note: Your values and the number of accounts you've created may be different than mine.


At this point and time we verified that the functionality of the app works, but that page we got after we made a new transaction wasn't very helpful. You can get back to it by visiting [http://localhost:3000/transactions/1](http://localhost:3000/transactions/1).

We are going to make this page a bit more helpful. Open up `app/views/transactions/show.html.erb`.

It looks like this:

```erb
:::-> $ cat app/views/transactions/show.html.erb
```

In this view you can see where it is rendering the "to account"

```erb
:::-> $ cat app/views/transactions/show.html.erb | grep @transaction.to_account
```

Replace that line with some more information:


```erb
  <ul>
    <li>Account ID: <%= @transaction.to_account.id %></li>
    <li>User Name: <%= @transaction.to_account.user.name %></li>
    <li>Account Balance: <%= @transaction.to_account.balance %></li>
  </ul>
```

Refresh the page, it should be much more useful now:

![](https://www.dropbox.com/s/4owfyzd6cfu9tdn/Screenshot%202018-04-03%2008.47.29.png?raw=1)

Repeat the process to change the `from_account`, using this code:

```erb
  <ul>
    <li>Account ID: <%= @transaction.from_account.id %></li>
    <li>User Name: <%= @transaction.from_account.user.name %></li>
    <li>Account Balance: <%= @transaction.from_account.balance %></li>
  </ul>
```

The file should look something like this:

```erb
:::-> file.write app/views/transactions/show.html.erb
<p id="notice"><%= notice %></p>

<p>
  <strong>From account:</strong>
  <ul>
    <li>Account ID: <%= @transaction.from_account.id %></li>
    <li>User Name: <%= @transaction.from_account.user.name %></li>
    <li>Account Balance: <%= @transaction.from_account.balance %></li>
  </ul>
</p>

<p>
  <strong>To account:</strong>
  <ul>
    <li>Account ID: <%= @transaction.to_account.id %></li>
    <li>User Name: <%= @transaction.to_account.user.name %></li>
    <li>Account Balance: <%= @transaction.to_account.balance %></li>
  </ul>
</p>

<p>
  <strong>Amount:</strong>
  <%= @transaction.amount %>
</p>

<%= link_to 'Edit', edit_transaction_path(@transaction) %> |
<%= link_to 'Back', transactions_path %>
```

When the page renders it should show more information for both the "from" and the "to" accounts:

![](https://www.dropbox.com/s/pzen1ij9mzgxp1t/Screenshot%202018-04-03%2008.49.44.png?raw=1)

While this app doesn't look like a bank, it acts kind of like a bank. There's still a bunch of UI that needs to be polished, and a ton of non-trivial features that we would need to add. In general to add a feature to this app you'll follow a similar pattern to what we've done here:

Start by making a mental outline of what components are needed for that feature. Do you already have the data you need, or does the feature require a new database backed model? Can the UI for the feature be added to an existing view, or does it need a new view? Is a controller set up to deliver that data to the view? Finally are there routes to that controller?

When thinking about designing a feature around a model you'll want to think in terms of Create, Read, Update, Delete. How do you make the model for the first time? How do you display it? How will it be edited? How will it be deleted? In development these considerations are reduced to the acronym CRUD. While not every feature has to be CRUD backed, it's a helpful exercise to consider these things as the feature is being prototyped.

While that process should seem at least somewhat familiar based on what we've already done, there is a key part in programming that we haven't covered: edge cases.

Go back to your new transaction page [http://localhost:3000/transactions/new](http://localhost:3000/transactions/new). Now enter in `1` for "from" account and `2` in the "to" account. Instead of a small number, try using a number that is way bigger than is in the first account, try 10,000. Now submit the form.

![](https://www.dropbox.com/s/saosu0ud2ugiuy4/Screenshot%202018-04-03%2008.56.48.png?raw=1)

Notice that one of the accounts went negative. In real life what would the bank have done? Should it have warned you that the funds could not exceed the amount in the balance? Would it ask you to set up overdraft protection? Would someone have called you to confirm the transaction? These are all things to think about.

Go back and make another new transaction [http://localhost:3000/transactions/new](http://localhost:3000/transactions/new). This time instead of 10,000 enter in -10,000. Looks like our account is back in order, but should the UI really allow you to transfer money out of anyone's account and into yours? Probably not.

In a real life app we would have to think of all these edge cases and account for them in our code. When most people talk about the features they talk about the "happy path", or the path of least resistance where everything goes right. A well developed feature should be easy to use, but also be prepared to fail gracefully and give the user the information they need to get back to the "happy path" of using the product as intented.


## Done

That's it.

Vocab:

- Database:
  - Primary key: A value for each record that does not change, even as other fields in the database record are mutated.
  - Foreign key: A value in one database record that points to the primary key of another database record.
- CRUD: Create, Read, Update, Delete