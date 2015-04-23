# Sous-Chef

![Sous-Chef](http://res.cloudinary.com/drd0r2vfh/image/upload/v1429243638/sous_chef_riw2af.png)

## Description
*Sous-Chef is an app where online recipe lovers can assemble all their recipes for the week, and have their shopping list texted to their phone.*

I love finding new online recipes, but every time I decide to cook something, there's usually a bunch of ingredients I don't have, and I often don't have time to go to the store every time I want to cook something new.  Sous-Chef makes this easier by compiling all of the recipes your planning to cook (for the week or so), and texting the ingredient list to your phone.  That way, when you finally have to time to make it to the store, your shopping list is right there for you to pull up!

## Technologies Used

- Back End: Sinatra, ActiveRecord, PostgreSQL
- Front End: JavaScript, jQuery, Handlebars.js, HTML, CSS, Bootstrap
- API's: Yummly, Twilio

## Challenges

One of the first challenges I came upon was parsing the Yummly JSON response to include what I needed.  It is a HUGE object, containing all sorts of allergy/diet/nutritional information.  Perhaps one day that information could be implemented, but for my MVP purposes it wasn't necessary.  The search function is done via AJAX, and the results are displayed using a Handlebars template.

When creating a recipe, I wanted a dynamic user experience, where they could add ingredients as they see fit.  The tricky part is that those ingredients need to be associated with the recipe in my database, and there is only one ingredient in my initial html form.  So I needed a way to keep track of an undeclared amount of ingredients, and associate them with the recipe at the time of creation.  My workaround was to use jQuery and AJAX.  When the user clicks submit, I used jQuery to collect all the ingredients (by class name), and send all the information to my server as data in my AJAX call.

## Next Steps

I originally envisioned this app to have more of a user-to-user experience.  Using Yummly is great, but I would like it if users could upload their own recipes, and share them with friends.  Also, an essential part of the online-recipe world is to upload pictures, so I would like to implement Cloudinary to allow users to upload photos of they're recipes.

Lastly, my free versions of the Yummly and Twilio API's have severe limitations.  The image size for the Yummly recipes is much too small, and my Twilio account can only use phone numbers that I personally register with them.

*Sous-Chef was created as a project for phase 2 (week 6) of Dev Bootcamp SF*
