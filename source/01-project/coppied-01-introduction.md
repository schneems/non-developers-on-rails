## Welcome

This is a seat of the pants introduction to webprogramming through the lense of a non-developer. The goal is to get you exposed to terminology and concepts so that you can have better conversations with developers.

To accomplish this, we will walk through a tutorial step by step and I will introduce and highlight terms and concepts. It's not 100% necessarry to absorb and understand everything that you're doing, however you shouldn't be totally lost either.

If you get stuck go back a few commands and ensure that everything ran correctly. Most commands will also include a "check" step to make sure the output.

> Note: Also try reading below the current command, there may be a `Note:` section with additional details.

> Extra: There may be "extra" sections with details you can explore if you want to know more, but aren't strictly necessary.

## Command Line Basics

Before you can get started it helps to be somewhat familiar with the command line.

https://www.schneems.com/post/26569696837/command-line-basics

All instructions that are meant to be run on the command line will start with a dollar symbol like this:

```sh
$ ls
```

Do not type in the dollar sign, if you do you might get an error like this:

```sh
:::>> fail.$ $ ls
```

## Setup Ruby and Rails

The next thing to do is set up Ruby and Rails.

http://guides.railsgirls.com/install#setup-for-os-x

You need to use a version of Ruby greater than 2.3, it's fine if you're not using the exact same version as these instructions, but it will work better if you do. These instructions were created using:

```sh
$ ruby -v
```

## Verify Setup and Create a Rails App

I like to have all my programming projects in an organized directory.

In the command line make a new directory called `projects` and move into that directory:

```sh
$ mkdir projects
$ cd projects
```

For this course we'll be using Rails 5.1.6 which may be different than what is installed on your computer.

Run:

```sh
:::> $ gem install rails -v 5.1.6 --no-document
```

> Extra: The `gem` command is used to install libraries that are used by Ruby. Rails is one such library. The `-v` flag designates the version you want installed, if you omit it then you'll get the latest version. The `--no-document` switch tells the `gem` command to not parse and generate documentaion for Rails locally. Don't worry it's still available online. Open source libraries for Ruby are hosted at https://www.rubygems.org. You can get more info about available commands to `gem` by running `$ gem --help`

Now that you're in your own project directory ensure that Rails is installed and working by running:

> Note: While this output might be long and intimidating it's here so you can debug your app if there's any issues. It should be the same.

```sh
:::>> $ rails _5.1.6_ new my_bank_app
```

 > Extra: The `rails` command was installed via the `gem` command, not all gems install CLI (command line interface) commands. The `_5.1.6_` part is an advanced feature that lets us specify exactly which version of `rails` to use if multiple are on the machine. Once you are working inside of an existing project you won't need to specify version in this way. The `new` is a command to `rails` to create a new project directory. The `my_bank_app` is the name of our project directory. You can get more info about these options by running `$ rails _5.1.6_ --help`.


Now that you've created a new Rails project, move into the new directory and start your Rails server:

```sh
:::>> $ cd my_bank_app
```

```sh
$ rails server
:::-- fail.$ gtimeout 10s rails s
:::-> | $ head -n 9
```

Now open a browser and enter in `localhost:3000` in the address bar. You should see a webpage that looks like this:

![](https://www.dropbox.com/s/ozhx3u7pa5fswah/Screenshot%202018-03-29%2015.02.38.png?raw=1)

If you see that page, congrats you did the hardest part which is getting started. If you didn't then carefully re-trace instructions and compare your output to whats in the above examples. If you're using the exact same version of Ruby and Rails, the output should be identical.

It may seem like a bunch of hoops to jump through, but we'll use all these tools to build a simple webapp.

You should get out of this project directory
