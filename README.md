# The Riddlebook
The riddlebook is a small CLI(command-line interface) application where the User/Player is able to make, store, and solve riddles.

## Installation
To install this CLI application in any directory of choice run the following
`git clone https://github.com/arieldavis22/ruby-project-alt-guidelines-atlanta-web-021720.git`

## Running this CLI Application
To run this CLI application first in your terminal run
`rake db:migrate`
then
`rake db:seed`
lastly run
`ruby bin/run.rb`

## Using The Riddlebook
When the application starts, the **User** will make a new account by selecting **New**.

They will be prompt to enter the following in order:
**Username**
**Title for login title**
**Context of login title**
**Answer to login title**

The **User** will then be redirected back to the home menu.
From here, select **Returning**
This will prompt the **User** to enter in the following:
**Username**
**Login riddle password**

Once the correct credentials are entered, the **User** will be brought to the **Main Menu** where they are able to:

**See My Riddles**: See all the riddles of the current user.
**Make A New Riddle**: Make a new riddle for the current user (create a new title, context, and answer for your riddle).
**Edit My Riddle**: Select from the current users riddle and choose if they wish to edit the title, context, or answer for said riddle.
**Delete My Riddles**: Select a riddle to delete (must have created a riddle besides the login riddle).
**Answer Other Riddles**: Select other users riddles and answer them.

> Made by Ariel Davis
> With Ruby
> README written with [StackEdit](https://stackedit.io/).

