$(document).ready(function() {

  $("#search-form").submit(function(event){
    event.preventDefault();
    var keywords = $('#input-text').val();

    $.ajax({
      type: 'GET',
      url: '/searchResults/' + keywords,
      dataType: 'json',
    })
    .done(function (response) {
      console.log(response)
      $('#results').empty();
      displayAllRecipes(response)
    })
    .fail(function(response){
      console.log("display recipes failed")
    })
  })

  // $('body').on('click', '.viewRecipe', displayRecipe);


  $('.create-recipe-form').on("submit", function(event){
    event.preventDefault();
    var ingredient_array = []
    $('.ingredient-text').each(function(){
      ingredient_array.push($(this).val())
    })
    var recipeName = $('.recipe-name').val()
    var recipeInstructions = $('.recipe-instructions').val()
    console.log(ingredient_array)
    console.log(recipeName)
    console.log(recipeInstructions)

    $.ajax ({
      type: "POST",
      url: "/recipe/create",
      data: {ingredient : ingredient_array, recipe_name : recipeName, instructions : recipeInstructions}
    })
    .done(function(){
      console.log("Success create recipe")
      // redirect_url = window.location.protocol + window.location.host + '/'
      // window.location.replace(redirect_url) //SORRY!! count't figure out any other way to do this...

    })
    .fail(function(){
      console.log("Failed create recipe")
    })
  });

  $('.recipe-img').hover(function() {
    $('.recipe-img').addClass('blow-up');
  }, function() {
        $('.recipe-img').removeClass('blow-up');
    });





  var counter = 1
  $('body').on('click', '.add-ingredient-button', function(event){
    event.preventDefault()
    ingredient_name = $('.ingredient-text').val()

    counter += 1
    $(this).remove()
    $('.add-ingredient-form').append("<div class='form-group'><label for='exampleInputPassword1'>Ingredient " + counter + "</label><input type='text' name='ingredient_name' class='form-control ingredient-text' placeholder='e.g. 2 cups of flour'></div><div class='form-group'><button class='add-ingredient-button'>Add Ingredient</button></div>");

  })

});


function displayAllRecipes(response) {
  matches = response
  var source   = $("#recipe-template").html();
  var template = Handlebars.compile(source);

  matches.forEach(function(element) {
    var recipeId = element.id
    var img = element.imageUrlsBySize[90]
    var rating = element.rating
    var recipeName = element.recipeName
    var totalTime = element.totalTimeInSeconds

    var context = {recipeId: recipeId, imgUrl: img, rating: rating, time: (totalTime / 60), recipeName: recipeName};
    var html    = template(context);
    $('#results').append(html)
  })
}

// function displayRecipe(response) {
//   event.preventDefault()
//   id = $(this).attr('href')
//   $.ajax({
//     type: 'GET',
//     url: '/recipe/search/' + id,
//   }).done(function(response){
//     console.log("made it through");
//     console.log(response)
//     $('#results').children().remove();
//     $('#results').append(response);
//   }).fail(function(response){
//     console.log("failed display recipe")
//     console.log(response)
//   })

// }
